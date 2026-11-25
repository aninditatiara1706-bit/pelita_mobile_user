import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/auth_service.dart';
import '../models/antrean_model.dart';

class AntreanRepository {
  static const String _keyAntreanId = 'antrean_id_aktif';
  static const String _keyDaftarAntrean = 'daftar_antrean_id';

  static const int estimasiMenitPerPeserta = 10;

// =========================
// BUAT MODEL ANTREAN
// =========================

AntreanModel buatAntrean({
  required String tanggal,
  required String waktu,
  required String namaPeserta,
  required String nomorAntrean,
  required String namaPosyandu,
  required String nomorSedangDilayani,
  required String estimasi,
}) {
  return AntreanModel(
    tanggal: tanggal,
    waktu: waktu,
    namaPeserta: namaPeserta,
    nomorAntrean: nomorAntrean,
    namaPosyandu: namaPosyandu,
    nomorSedangDilayani: nomorSedangDilayani,
    estimasi: estimasi,
  );
}

  // =========================================================
  // SIMPAN ID ANTREAN
  // =========================================================

  Future<void> simpanAntreanId(String id) async {
    if (id.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();

    final daftar = prefs.getStringList(_keyDaftarAntrean) ?? [];

    // Jangan simpan ID yang sama dua kali.
    if (!daftar.contains(id)) {
      daftar.add(id);
    }

    await prefs.setStringList(_keyDaftarAntrean, daftar);

    // Simpan ID terbaru sebagai kompatibilitas dengan kode lama.
    await prefs.setString(_keyAntreanId, id);
  }

  // =========================================================
  // AMBIL SEMUA ID ANTREAN
  // =========================================================

  Future<List<String>> getDaftarAntreanId() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> daftar =
        prefs.getStringList(_keyDaftarAntrean) ?? [];

    // Migrasi data lama yang hanya menyimpan satu ID.
    final idLama = prefs.getString(_keyAntreanId);

    if (idLama != null &&
        idLama.isNotEmpty &&
        !daftar.contains(idLama)) {
      daftar.add(idLama);

      await prefs.setStringList(
        _keyDaftarAntrean,
        daftar,
      );
    }

    return daftar;
  }

  // =========================================================
  // AMBIL ID ANTREAN TERAKHIR
  // =========================================================

  Future<String?> getAntreanIdTersimpan() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_keyAntreanId);
  }

  // =========================================================
  // HAPUS SATU ID ANTREAN
  // =========================================================

  Future<void> hapusAntreanDariDaftar(String id) async {
    final prefs = await SharedPreferences.getInstance();

    final daftar =
        prefs.getStringList(_keyDaftarAntrean) ?? [];

    daftar.remove(id);

    await prefs.setStringList(
      _keyDaftarAntrean,
      daftar,
    );

    // Jika ID utama yang dihapus, ganti dengan ID berikutnya.
    final idUtama = prefs.getString(_keyAntreanId);

    if (idUtama == id) {
      if (daftar.isNotEmpty) {
        await prefs.setString(
          _keyAntreanId,
          daftar.last,
        );
      } else {
        await prefs.remove(_keyAntreanId);
      }
    }
  }

  // =========================================================
  // HAPUS SEMUA ID ANTREAN
  // =========================================================

  Future<void> hapusAntreanId() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_keyAntreanId);
    await prefs.remove(_keyDaftarAntrean);
  }

  // =========================================================
  // GET JSON
  // =========================================================

  Future<Map<String, dynamic>> _getJson(String url) async {
    final response = await AuthService.client
        .get(
          Uri.parse(url),
          headers: const {
            'Accept': 'application/json',
            'Cache-Control': 'no-cache',
          },
        )
        .timeout(const Duration(seconds: 15));

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Format respons backend tidak valid.');
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        decoded['success'] == false) {
      throw Exception(
        decoded['message']?.toString() ??
            'Gagal mengambil data antrean.',
      );
    }

    return decoded;
  }

  // =========================================================
  // GET ANTREAN BERDASARKAN ID
  // =========================================================

  Future<AntreanModel?> getAntreanById(String id) async {
    if (id.trim().isEmpty) return null;

    try {
      final decoded = await _getJson(
        '${AuthService.baseUrl}/antrean/$id',
      );

      final data = decoded['data'];

      if (data is! Map) return null;

      return AntreanModel.fromJson(
        Map<String, dynamic>.from(data),
      );
    } catch (_) {
      return null;
    }
  }

  // =========================================================
  // GET ANTREAN AKTIF
  // =========================================================

  Future<List<AntreanModel>> getAntreanAktifMilikAkun() async {
    final decoded = await _getJson(
      '${AuthService.baseUrl}/antrean/saya/aktif',
    );

    final data = decoded['data'];

    if (data is! List) {
      throw Exception(
        'Format daftar antrean aktif dari backend tidak valid.',
      );
    }

    return data.map((item) {
      if (item is! Map) {
        throw Exception(
          'Data antrean aktif dari backend tidak valid.',
        );
      }

      return AntreanModel.fromJson(
        Map<String, dynamic>.from(item),
      );
    }).toList();
  }

  Future<AntreanModel> getAntreanAktif() async {
    final antreanAktif =
        await getAntreanAktifMilikAkun();

    if (antreanAktif.isNotEmpty) {
      return antreanAktif.first;
    }

    throw Exception('Tidak ada antrean aktif.');
  }

  // =========================================================
  // GET ANTREAN PADA JADWAL
  // =========================================================

  Future<List<Map<String, dynamic>>> getAntreanJadwal(
    String jadwalId,
  ) async {
    if (jadwalId.isEmpty) return [];

    final decoded = await _getJson(
      '${AuthService.baseUrl}/antrean?jadwalId=$jadwalId',
    );

    final data = decoded['data'];

    if (data is! List) return [];

    return data
        .where((item) => item is Map)
        .map(
          (item) => Map<String, dynamic>.from(item as Map),
        )
        .toList();
  }

  // =========================================================
  // REFRESH STATUS ANTREAN
  // =========================================================

  Future<AntreanModel> refreshStatusAntrean(
    AntreanModel antrean,
  ) async {
    if (antrean.jadwalId.isEmpty) {
      return antrean;
    }

    final semuaAntrean = await getAntreanJadwal(
      antrean.jadwalId,
    );

    final sedangDilayani = semuaAntrean.where((item) {
      return item['status']
              ?.toString()
              .toUpperCase() ==
          'DIPERIKSA';
    }).toList();

    sedangDilayani.sort((a, b) {
      final nomorA =
          int.tryParse(a['noAntrean']?.toString() ?? '') ?? 0;

      final nomorB =
          int.tryParse(b['noAntrean']?.toString() ?? '') ?? 0;

      return nomorA.compareTo(nomorB);
    });

    String nomorSedangDilayani = '-';

    if (sedangDilayani.isNotEmpty) {
      final nomor = sedangDilayani.first['noAntrean'];

      final angka = int.tryParse(nomor?.toString() ?? '');

      nomorSedangDilayani = angka != null
          ? 'A-${angka.toString().padLeft(2, '0')}'
          : nomor?.toString() ?? '-';
    }

    final menungguSebelum = semuaAntrean.where((item) {
      final status =
          item['status']?.toString().toUpperCase();

      final nomor =
          int.tryParse(item['noAntrean']?.toString() ?? '') ?? 0;

      return status == 'MENUNGGU' &&
          nomor < antrean.nomorAntreanAngka;
    }).length;

    final statusPengguna =
        antrean.status.toUpperCase();

    String estimasi;

    if (statusPengguna == 'DIPERIKSA') {
      estimasi = 'Giliran Anda sedang dilayani';
    } else if (statusPengguna == 'SELESAI') {
      estimasi = 'Pemeriksaan telah selesai';
    } else if (statusPengguna == 'BATAL') {
      estimasi = 'Antrean dibatalkan';
    } else if (menungguSebelum == 0) {
      estimasi = 'Giliran Anda berikutnya';
    } else {
      estimasi =
          'Sekitar ${menungguSebelum * estimasiMenitPerPeserta} menit lagi';
    }

    return antrean.copyWith(
      nomorSedangDilayani: nomorSedangDilayani,
      estimasi: estimasi,
    );
  }
}