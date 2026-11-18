import 'package:flutter/material.dart';

import '../models/pendaftaran_model.dart';
import '../repositories/pendaftaran_repositories.dart';

class PendaftaranViewModels extends ChangeNotifier {
  final PendaftaranRepositories _repository;

  PendaftaranViewModels({PendaftaranRepositories? repository})
    : _repository = repository ?? PendaftaranRepositories();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<bool> simpanPendaftaran(PendaftaranModel data) async {
    if (_isLoading) return false;

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;

    notifyListeners();

    try {
      final message = await _repository.simpanPendaftaran(data);

      _successMessage = message;

      return true;
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('Exception: ', '');

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetMessage() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
