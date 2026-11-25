import 'package:flutter/material.dart';

import '../repositories/profil_peserta_repository.dart';
import '../models/peserta_model.dart';

class ProfilPesertaViewModel extends ChangeNotifier {
  final Peserta peserta;
  final ProfilPesertaRepository _repository;

  ProfilPesertaViewModel({
    required this.peserta,
    ProfilPesertaRepository? repository,
  }) : _repository = repository ?? ProfilPesertaRepository();

  // =========================
  // STATE
  // =========================

  bool _loadingDetail = true;
  String? _errorDetail;

  int _selectedGrafik = 0;
  int _selectedPeriode = 3;

  List<MapEntry<String, double>> _dataBerat = [];
  List<MapEntry<String, double>> _dataTinggi = [];
  List<MapEntry<String, double>> _dataLingkarKepala = [];

  String _terakhirDiperiksa = '-';

  // =========================
  // GETTER STATE
  // =========================

  bool get loadingDetail => _loadingDetail;

  String? get errorDetail => _errorDetail;

  int get selectedGrafik => _selectedGrafik;

  int get selectedPeriode => _selectedPeriode;

  List<MapEntry<String, double>> get dataBerat => _dataBerat;

  List<MapEntry<String, double>> get dataTinggi => _dataTinggi;

  List<MapEntry<String, double>> get dataLingkarKepala =>
      _dataLingkarKepala;

  String get terakhirDiperiksa => _terakhirDiperiksa;

  // =========================
  // KATEGORI PESERTA
  // =========================

  bool get isLansia =>
      peserta.kategori.toLowerCase().contains('lansia');

  List<String> get jenisGrafik => isLansia
      ? [
          'Tekanan Darah',
          'Berat Badan',
          'Gula Darah',
          'Denyut Nadi',
        ]
      : [
          'Berat',
          'Tinggi Badan',
          'Lingkar Kepala',
        ];

  // =========================
  // LOAD DETAIL PESERTA
  // =========================

  Future<void> muatDetailPeserta() async {
    _loadingDetail = true;
    _errorDetail = null;

    notifyListeners();

    try {
      final detail = await _repository.getDetailPeserta(
  peserta.id,
);

      final rawPemeriksaan =
          detail['pemeriksaan'] as List<dynamic>? ?? [];

      final daftar = rawPemeriksaan
          .map(
            (item) => Map<String, dynamic>.from(item as Map),
          )
          .toList();

      // URUTKAN TANGGAL PEMERIKSAAN
      daftar.sort((a, b) {
        final tanggalA = DateTime.tryParse(
              (a['tanggalPemeriksaan'] ?? '').toString(),
            ) ??
            DateTime(2000);

        final tanggalB = DateTime.tryParse(
              (b['tanggalPemeriksaan'] ?? '').toString(),
            ) ??
            DateTime(2000);

        return tanggalA.compareTo(tanggalB);
      });

      // AMBIL DATA GRAFIK
      _dataBerat = ambilDataGrafik(
        daftar,
        'beratBadan',
      );

      _dataTinggi = ambilDataGrafik(
        daftar,
        'tinggiBadan',
      );

      _dataLingkarKepala = ambilDataGrafik(
        daftar,
        'lingkarKepala',
      );

      // PEMERIKSAAN TERAKHIR
      if (daftar.isNotEmpty) {
        _terakhirDiperiksa = formatTanggalPemeriksaan(
          daftar.last['tanggalPemeriksaan'],
        );
      } else {
        _terakhirDiperiksa = '-';
      }

      _loadingDetail = false;
    } catch (e) {
      _loadingDetail = false;
      _errorDetail = e.toString();
    }

    notifyListeners();
  }

  // =========================
  // AMBIL DATA GRAFIK
  // =========================

  List<MapEntry<String, double>> ambilDataGrafik(
    List<Map<String, dynamic>> daftar,
    String field,
  ) {
    final hasil = <MapEntry<String, double>>[];

    for (final pemeriksaan in daftar) {
      final nilai = double.tryParse(
        (pemeriksaan[field] ?? '').toString(),
      );

      if (nilai == null) continue;

      hasil.add(
        MapEntry(
          labelTanggalGrafik(
            pemeriksaan['tanggalPemeriksaan'],
          ),
          nilai,
        ),
      );
    }

    return hasil;
  }

  // =========================
  // FORMAT TANGGAL
  // =========================

  String formatTanggalPemeriksaan(dynamic value) {
    if (value == null) return '-';

    final tanggal = DateTime.tryParse(value.toString());

    if (tanggal == null) return '-';

    return '${tanggal.day.toString().padLeft(2, '0')}-'
        '${tanggal.month.toString().padLeft(2, '0')}-'
        '${tanggal.year}';
  }

  String labelTanggalGrafik(dynamic value) {
    if (value == null) return '-';

    final tanggal = DateTime.tryParse(value.toString());

    if (tanggal == null) return '-';

    const namaBulan = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${namaBulan[tanggal.month - 1]} ${tanggal.year}';
  }

  // =========================
  // PILIH GRAFIK
  // =========================

  void pilihGrafik(int index) {
    _selectedGrafik = index;
    notifyListeners();
  }

  // =========================
  // PILIH PERIODE
  // =========================

  void pilihPeriode(int bulan) {
    _selectedPeriode = bulan;
    notifyListeners();
  }

  // =========================
  // DATA GRAFIK AKTIF
  // =========================

  List<double> getCurrentData() {
    if (isLansia) {
      switch (_selectedGrafik) {
        case 0:
          return [];

        case 1:
          return _dataBerat
              .map((item) => item.value)
              .toList();

        case 2:
          return [];

        case 3:
          return [];

        default:
          return [];
      }
    }

    switch (_selectedGrafik) {
      case 0:
        return _dataBerat
            .map((item) => item.value)
            .toList();

      case 1:
        return _dataTinggi
            .map((item) => item.value)
            .toList();

      case 2:
        return _dataLingkarKepala
            .map((item) => item.value)
            .toList();

      default:
        return _dataBerat
            .map((item) => item.value)
            .toList();
    }
  }

  // =========================
  // TANGGAL GRAFIK AKTIF
  // =========================

  List<String> getCurrentDates() {
    if (isLansia) {
      if (_selectedGrafik == 1) {
        return _dataBerat
            .map((item) => item.key)
            .toList();
      }

      return [];
    }

    switch (_selectedGrafik) {
      case 0:
        return _dataBerat
            .map((item) => item.key)
            .toList();

      case 1:
        return _dataTinggi
            .map((item) => item.key)
            .toList();

      case 2:
        return _dataLingkarKepala
            .map((item) => item.key)
            .toList();

      default:
        return _dataBerat
            .map((item) => item.key)
            .toList();
    }
  }

  // =========================
  // SATUAN GRAFIK
  // =========================

  String getCurrentUnit() {
    if (isLansia) {
      switch (_selectedGrafik) {
        case 0:
          return 'mmHg';

        case 1:
          return 'kg';

        case 2:
          return 'mg/dL';

        case 3:
          return 'bpm';

        default:
          return '';
      }
    }

    return _selectedGrafik == 0 ? 'kg' : 'cm';
  }

  // =========================
  // WARNA GRAFIK
  // =========================

  Color getWarnaGrafik() {
    return const Color(0xFF9148D8);
  }

  // =========================
  // MINIMUM Y
  // =========================

  double getMinY(List<double> data) {
    switch (_selectedGrafik) {
      case 0:
        return 5;

      case 1:
        return 65;

      case 2:
        return 40;

      default:
        return 0;
    }
  }

  // =========================
  // MAXIMUM Y
  // =========================

  double getMaxY(List<double> data) {
    switch (_selectedGrafik) {
      case 0:
        return 13;

      case 1:
        return 105;

      case 2:
        return 52;

      default:
        return 100;
    }
  }

  // =========================
  // INTERVAL GRAFIK
  // =========================

  double getInterval(List<double> data) {
    switch (_selectedGrafik) {
      case 0:
        return 2;

      case 1:
        return 10;

      case 2:
        return 3;

      default:
        return 10;
    }
  }
}