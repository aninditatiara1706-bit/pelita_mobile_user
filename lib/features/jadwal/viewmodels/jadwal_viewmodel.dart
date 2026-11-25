import 'package:flutter/material.dart';

import '../models/jadwal_model.dart';
import '../repositories/jadwal_repository.dart';

class JadwalViewModel extends ChangeNotifier {
  final JadwalRepository _repository;

  JadwalViewModel({
    required JadwalRepository repository,
  }) : _repository = repository;

  List<JadwalPosyandu> _jadwal = [];

  List<JadwalPosyandu> get jadwal => _jadwal;

  int _selectedJadwal = -1;

  int get selectedJadwal => _selectedJadwal;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  // ================================================
  // MEMUAT DATA JADWAL
  // ================================================

  Future<void> muatJadwal() async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _jadwal = await _repository.ambilJadwal();

      // Jadwal pertama otomatis terpilih
      // hanya jika tersedia dan belum penuh.
      _selectedJadwal = -1;

      for (int i = 0; i < _jadwal.length; i++) {
        if (_jadwal[i].tersedia) {
          _selectedJadwal = i;
          break;
        }
      }
    } catch (e) {
      _errorMessage = 'Gagal memuat jadwal Posyandu';

      debugPrint('Error memuat jadwal: $e');
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // ================================================
  // MEMILIH JADWAL
  // ================================================

  void pilihJadwal(int index) {
    if (index < 0 || index >= _jadwal.length) {
      return;
    }

    // Jadwal penuh tidak bisa dipilih.
    if (_jadwal[index].penuh) {
      return;
    }

    _selectedJadwal = index;

    notifyListeners();
  }

  // ================================================
  // JADWAL TERPILIH
  // ================================================

  JadwalPosyandu? get jadwalTerpilih {
    if (_selectedJadwal < 0 ||
        _selectedJadwal >= _jadwal.length) {
      return null;
    }

    final jadwal = _jadwal[_selectedJadwal];

    if (jadwal.penuh) {
      return null;
    }

    return jadwal;
  }

  // ================================================
  // REFRESH
  // ================================================

  Future<void> refreshJadwal() async {
    await muatJadwal();
  }
}