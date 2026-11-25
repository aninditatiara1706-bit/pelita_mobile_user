import 'package:flutter/material.dart';

import '../models/riwayat_pelayanan_model.dart';
import '../repositories/riwayat_pelayanan_repository.dart';

class RiwayatPelayananViewModel extends ChangeNotifier {
  final RiwayatPelayananRepository _repository;

  RiwayatPelayananViewModel({
    RiwayatPelayananRepository? repository,
  }) : _repository =
            repository ?? RiwayatPelayananRepository();

  List<RiwayatPelayananModel> _riwayat = [];

  String _searchQuery = '';

  bool _isLoading = false;

  String? _errorMessage;

  List<RiwayatPelayananModel> get riwayat => _riwayat;

  String get searchQuery => _searchQuery;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  List<RiwayatPelayananModel> get hasilPencarian {
    if (_searchQuery.isEmpty) {
      return _riwayat;
    }

    return _riwayat.where((item) {
      return item.name.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  Future<void> loadRiwayatPelayanan() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _riwayat = await _repository.getRiwayatPelayanan();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void searchRiwayat(String query) {
    _searchQuery = query.toLowerCase().trim();
    notifyListeners();
  }
}