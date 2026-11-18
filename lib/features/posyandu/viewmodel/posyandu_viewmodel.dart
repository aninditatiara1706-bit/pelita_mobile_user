
import 'package:flutter/material.dart';

import '../models/posyandu_model.dart';
import '../repositories/posyandu_repository.dart';

class PosyanduViewModel extends ChangeNotifier {
  final PosyanduRepository _repository;

  PosyanduViewModel({
    required PosyanduRepository repository,
  }) : _repository = repository;

  // ================================================
  // STATE PESERTA
  // ================================================

  List<PesertaPosyandu> _peserta = [];

  List<PesertaPosyandu> get peserta => _peserta;

  int _selectedPeserta = 0;

  int get selectedPeserta => _selectedPeserta;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  // ================================================
  // MEMUAT DATA PESERTA
  // ================================================

  Future<void> muatPeserta() async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _peserta = await _repository.ambilPeserta();

      if (_peserta.isEmpty) {
        _selectedPeserta = 0;
      } else if (_selectedPeserta >= _peserta.length) {
        _selectedPeserta = 0;
      }
    } catch (e) {
      _errorMessage = 'Gagal memuat data peserta';

      debugPrint('Error memuat peserta: $e');
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // ================================================
  // MEMILIH PESERTA
  // ================================================

  void pilihPeserta(int index) {
    if (index < 0 || index >= _peserta.length) {
      return;
    }

    _selectedPeserta = index;

    notifyListeners();
  }

  // ================================================
  // MENGAMBIL PESERTA YANG DIPILIH
  // ================================================

  PesertaPosyandu? get pesertaTerpilih {
    if (_peserta.isEmpty ||
        _selectedPeserta >= _peserta.length) {
      return null;
    }

    return _peserta[_selectedPeserta];
  }

  String? get namaPesertaTerpilih {
    return pesertaTerpilih?.nama;
  }
}
