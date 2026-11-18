
import 'package:flutter/material.dart';

import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationRepository _repository;

  NotificationViewModel({
    required NotificationRepository repository,
  }) : _repository = repository;

  // ================================================
  // STATE
  // ================================================

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  List<AntreanNotification> _antreanSaya = [];

  List<AntreanNotification> get antreanSaya => _antreanSaya;

  List<JadwalNotification> _jadwalHariIni = [];

  List<JadwalNotification> get jadwalHariIni =>
      _jadwalHariIni;

  // ================================================
  // FETCH NOTIFICATIONS
  // ================================================

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final result = await _repository.ambilNotifikasi();

      _antreanSaya = result.antrean;
      _jadwalHariIni = result.jadwal;

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();

      debugPrint('Notification ViewModel Error: $e');
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // ================================================
  // FORMAT TANGGAL
  // ================================================

  String formatTanggal(dynamic value) {
    if (value == null) return '-';

    try {
      final date = DateTime.parse(value.toString());

      return '${date.day.toString().padLeft(2, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.year}';
    } catch (_) {
      return value.toString();
    }
  }

  // ================================================
  // FORMAT JAM
  // ================================================

  String formatJam(dynamic value) {
    if (value == null) return '';

    final text = value.toString();

    if (text.contains('T')) {
      return text.substring(11, 16);
    }

    return text.length >= 5
        ? text.substring(0, 5)
        : text;
  }

  // ================================================
  // STATUS ANTREAN
  // ================================================

  String statusAntrean(String status) {
    switch (status) {
      case 'DIPERIKSA':
        return 'Sedang dalam pemeriksaan.';

      case 'MENUNGGU':
        return 'Antrean kamu sedang menunggu dipanggil.';

      default:
        return 'Status antrean: $status';
    }
  }

  // ================================================
  // DISPOSE
  // ================================================

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}
