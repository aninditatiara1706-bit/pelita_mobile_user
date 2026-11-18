import 'package:flutter/material.dart';

import '../models/dashboard_model.dart';
import '../repositories/dashboard_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardRepository repository;

  DashboardViewModel({DashboardRepository? repository})
    : repository = repository ?? DashboardRepository();

  String namaUser = 'Pengguna';

  int unreadCount = 0;

  bool loadingUser = true;
  bool loadingNotifikasi = true;
  bool loadingGrafik = true;

  List<GrowthRecord> riwayatPertumbuhan = [];

  bool _disposed = false;

  Future<void> muatDashboard() async {
    await Future.wait([muatUser(), muatNotifikasi(), muatGrafik()]);
  }

  Future<void> muatUser() async {
    try {
      final user = await repository.getUser();

      _update(() {
        namaUser = user.nama.isNotEmpty ? user.nama : 'Pengguna';

        loadingUser = false;
      });
    } catch (e) {
      debugPrint('Gagal memuat user: $e');

      _update(() {
        loadingUser = false;
      });
    }
  }

  Future<void> muatNotifikasi() async {
    try {
      final jumlah = await repository.getUnreadCount();

      _update(() {
        unreadCount = jumlah;
        loadingNotifikasi = false;
      });
    } catch (e) {
      debugPrint('Gagal memuat notifikasi: $e');

      _update(() {
        unreadCount = 0;
        loadingNotifikasi = false;
      });
    }
  }

  Future<void> muatGrafik() async {
    try {
      final hasil = await repository.getGrowthRecords();

      _update(() {
        riwayatPertumbuhan = hasil;
        loadingGrafik = false;
      });
    } catch (e) {
      debugPrint('Gagal memuat grafik: $e');

      _update(() {
        riwayatPertumbuhan = [];
        loadingGrafik = false;
      });
    }
  }

  bool get tampilkanGrafik {
    return !loadingGrafik && riwayatPertumbuhan.isNotEmpty;
  }

  void _update(VoidCallback callback) {
    if (_disposed) return;

    callback();
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    repository.dispose();
    super.dispose();
  }
}
