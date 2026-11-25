import 'package:flutter/foundation.dart';

import '../../../services/auth_service.dart';
import '../models/jadwal_model.dart';
import 'dart:convert';

class JadwalRepository {
  static const int kuotaMaksimal = 30;

  Future<List<JadwalPosyandu>> ambilJadwal() async {
    try {
      final response = await AuthService.client
          .get(
            Uri.parse('${AuthService.baseUrl}/jadwal'),
            headers: const {
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      debugPrint('====================================');
      debugPrint('STATUS API JADWAL: ${response.statusCode}');
      debugPrint('BODY API JADWAL: ${response.body}');
      debugPrint('====================================');

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw Exception('Format response jadwal tidak valid');
      }

      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          decoded['success'] != true) {
        throw Exception(
          decoded['message']?.toString() ??
              'Gagal mengambil jadwal Posyandu',
        );
      }

      final List<dynamic> data =
          decoded['data'] as List<dynamic>? ?? [];

      final sekarangWib = _waktuWib(DateTime.now());
      final hariIni = DateTime(
        sekarangWib.year,
        sekarangWib.month,
        sekarangWib.day,
      );

      final List<JadwalPosyandu> hasil = [];

      for (final item in data) {
        if (item is! Map) continue;

        final json = Map<String, dynamic>.from(item);

        final status =
            json['status']?.toString().toUpperCase() ?? '';

        if (status == 'SELESAI') {
          continue;
        }

        final tanggalRaw = json['tanggal'];

        if (tanggalRaw == null) {
          continue;
        }

        final tanggalDateTime =
            _tanggalWib(tanggalRaw.toString());

        if (tanggalDateTime == null) {
          continue;
        }

        final tanggalJadwal = DateTime(
          tanggalDateTime.year,
          tanggalDateTime.month,
          tanggalDateTime.day,
        );

        // Jadwal yang sudah lewat tidak ditampilkan.
        if (tanggalJadwal.isBefore(hariIni)) {
          continue;
        }

        final deskripsi =
            json['deskripsi']?.toString() ?? '';

        final countData = json['_count'];

        int jumlahAntrean = 0;

        if (countData is Map) {
          jumlahAntrean =
              int.tryParse(
                countData['antrean']?.toString() ?? '0',
              ) ??
              0;
        }

        hasil.add(
          JadwalPosyandu(
            id: json['id']?.toString() ?? '',
            tanggal: _formatTanggal(tanggalDateTime),
            waktu: _ambilWaktu(deskripsi),
            lokasi: json['lokasi']?.toString() ?? '-',
            status: status,
            terisi: jumlahAntrean,
            kuota: kuotaMaksimal,
          ),
        );
      }

      // Urutkan berdasarkan tanggal terdekat.
      hasil.sort((a, b) {
        final tanggalA = _parseTanggalIndonesia(a.tanggal);
        final tanggalB = _parseTanggalIndonesia(b.tanggal);

        if (tanggalA == null || tanggalB == null) {
          return 0;
        }

        return tanggalA.compareTo(tanggalB);
      });

      debugPrint('JUMLAH JADWAL AKTIF: ${hasil.length}');

      for (final jadwal in hasil) {
        debugPrint(
          '${jadwal.tanggal} | ${jadwal.lokasi} | '
          'Kuota ${jadwal.terisi}/${jadwal.kuota}',
        );
      }

      return hasil;
    } catch (e) {
      debugPrint('ERROR AMBIL JADWAL: $e');
      rethrow;
    }
  }

  // ================================================
  // KONVERSI WAKTU KE WIB (UTC+7)
  // ================================================

  DateTime _waktuWib(DateTime date) {
    return date.toUtc().add(const Duration(hours: 7));
  }

  DateTime? _tanggalWib(String value) {
    try {
      final parsed = DateTime.parse(value);

      // API menggunakan timestamp PostgreSQL.
      // Konversi eksplisit ke WIB agar tanggal konsisten.
      return parsed.toUtc().add(const Duration(hours: 7));
    } catch (_) {
      return null;
    }
  }

  // ================================================
  // MENGAMBIL WAKTU DARI DESKRIPSI
  // ================================================

  String _ambilWaktu(String deskripsi) {
    if (deskripsi.trim().isEmpty) {
      return '-';
    }

    final bagian = deskripsi
        .split('•')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final bagianBersih = bagian
        .where((e) => !e.contains('PELITA_DEMO'))
        .toList();

    if (bagianBersih.isEmpty) {
      return '-';
    }

    if (bagianBersih.length >= 2) {
      return bagianBersih[1];
    }

    return bagianBersih.first;
  }

  // ================================================
  // FORMAT TANGGAL INDONESIA
  // ================================================

  String _formatTanggal(DateTime date) {
    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${date.day} ${bulan[date.month - 1]} ${date.year}';
  }

  // ================================================
  // PARSE TANGGAL INDONESIA UNTUK SORTING
  // ================================================

  DateTime? _parseTanggalIndonesia(String tanggal) {
    try {
      final bagian = tanggal.split(' ');

      if (bagian.length != 3) {
        return null;
      }

      final hari = int.parse(bagian[0]);
      final tahun = int.parse(bagian[2]);

      const bulan = {
        'Januari': 1,
        'Februari': 2,
        'Maret': 3,
        'April': 4,
        'Mei': 5,
        'Juni': 6,
        'Juli': 7,
        'Agustus': 8,
        'September': 9,
        'Oktober': 10,
        'November': 11,
        'Desember': 12,
      };

      final bulanAngka = bulan[bagian[1]];

      if (bulanAngka == null) {
        return null;
      }

      return DateTime(tahun, bulanAngka, hari);
    } catch (_) {
      return null;
    }
  }
}