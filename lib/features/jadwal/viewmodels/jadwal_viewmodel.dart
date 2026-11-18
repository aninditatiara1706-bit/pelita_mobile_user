import 'package:flutter/material.dart';
import '../models/jadwal_model.dart';
import '../repositories/jadwal_repository.dart';

class JadwalViewModel extends ChangeNotifier {
  final JadwalRepository _repository;

  JadwalViewModel({
    required JadwalRepository repository,
  }) : _repository = repository;

  // ================================================
  // STATE JADWAL
  // ================================================

  List<JadwalPosyandu> _jadwal = [];

  List<JadwalPosyandu> get jadwal => _jadwal;

  int _selectedJadwal = 0;

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

      if (_jadwal.isEmpty) {
        _selectedJadwal = 0;
      } else if (_selectedJadwal >= _jadwal.length) {
        _selectedJadwal = 0;
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

    _selectedJadwal = index;

    notifyListeners();
  }

  // ================================================
  // MENGAMBIL JADWAL TERPILIH
  // ================================================

  JadwalPosyandu? get jadwalTerpilih {
    if (_jadwal.isEmpty ||
        _selectedJadwal >= _jadwal.length) {
      return null;
    }

    return _jadwal[_selectedJadwal];
  }
}
