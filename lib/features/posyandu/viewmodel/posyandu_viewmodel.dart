import 'package:flutter/material.dart';

import '../models/posyandu_model.dart';
import '../repositories/posyandu_repository.dart';

class PosyanduViewModel extends ChangeNotifier {
  final PosyanduRepository _repository;

  PosyanduViewModel({
    required PosyanduRepository repository,
  }) : _repository = repository;

  List<PesertaPosyandu> _peserta = [];

  List<PesertaPosyandu> get peserta => _peserta;

  int _selectedPeserta = -1;

  int get selectedPeserta => _selectedPeserta;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<void> muatPeserta() async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _peserta = await _repository.ambilPeserta();

      _selectedPeserta = _peserta.isEmpty ? -1 : 0;
    } catch (e) {
      _errorMessage = e.toString();

      debugPrint('Error memuat peserta: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void pilihPeserta(int index) {
    if (index < 0 || index >= _peserta.length) {
      return;
    }

    _selectedPeserta = index;
    notifyListeners();
  }

  PesertaPosyandu? get pesertaTerpilih {
    if (_selectedPeserta < 0 ||
        _selectedPeserta >= _peserta.length) {
      return null;
    }

    return _peserta[_selectedPeserta];
  }

  String? get namaPesertaTerpilih {
    return pesertaTerpilih?.nama;
  }

  String? get idPesertaTerpilih {
    return pesertaTerpilih?.id;
  }
}