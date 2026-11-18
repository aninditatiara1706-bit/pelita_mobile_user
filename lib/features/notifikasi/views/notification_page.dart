import 'package:flutter/material.dart';

import '../repositories/notification_repository.dart';
import '../viewmodels/notification_viewmodel.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  static const Color purple = Color(0xFFD04CD7);

  late final NotificationViewModel _viewModel;

  // ================================================
  // INIT STATE
  // ================================================

  @override
  void initState() {
    super.initState();

    _viewModel = NotificationViewModel(repository: NotificationRepository());

    _viewModel.fetchNotifications();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  // ================================================
  // WIDGET NOTIFIKASI
  // ================================================

  Widget notificationItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: purple, width: 2.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: purple),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11.5,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================
  // NOTIFIKASI ANTREAN
  // ================================================

  Widget buildAntreanNotifications() {
    final antreanSaya = _viewModel.antreanSaya;

    if (antreanSaya.isEmpty) {
      return notificationItem(
        icon: Icons.access_time_outlined,
        title: 'Belum Ada Antrean Aktif',
        description:
            'Kamu belum memiliki antrean Posyandu yang sedang berjalan.',
      );
    }

    return Column(
      children: antreanSaya.map((antrean) {
        final statusText = _viewModel.statusAntrean(antrean.status);

        return notificationItem(
          icon: Icons.access_time_outlined,
          title: 'Informasi Antrean Posyandu',
          description:
              'Peserta: ${antrean.namaPeserta}\n'
              'Nomor antrean: ${antrean.nomorAntrean}\n'
              '$statusText\n'
              'Tanggal: ${_viewModel.formatTanggal(antrean.tanggal)}',
        );
      }).toList(),
    );
  }

  // ================================================
  // NOTIFIKASI JADWAL
  // ================================================

  Widget buildJadwalNotifications() {
    final jadwalHariIni = _viewModel.jadwalHariIni;

    if (jadwalHariIni.isEmpty) {
      return notificationItem(
        icon: Icons.calendar_month_outlined,
        title: 'Jadwal Posyandu Hari Ini',
        description: 'Belum ada jadwal Posyandu untuk hari ini.',
      );
    }

    return Column(
      children: jadwalHariIni.map((jadwal) {
        final nama = jadwal.namaPosyandu;

        final jamMulai = _viewModel.formatJam(jadwal.jamMulai);

        final jamSelesai = _viewModel.formatJam(jadwal.jamSelesai);

        final waktu = jamMulai.isNotEmpty && jamSelesai.isNotEmpty
            ? '$jamMulai–$jamSelesai WIB'
            : 'Waktu belum tersedia';

        final lokasi = jadwal.lokasi;

        return notificationItem(
          icon: Icons.calendar_month_outlined,
          title: 'Jadwal Posyandu Hari Ini',
          description:
              '$nama • $waktu\n'
              '${lokasi.isNotEmpty ? '$lokasi\n' : ''}'
              'Jangan lupa datang sesuai jadwal ya!',
        );
      }).toList(),
    );
  }

  // ================================================
  // BUILD
  // ================================================

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12, left: 12),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 30,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    const SizedBox(height: 7),

                    const Center(
                      child: Text(
                        'Notifikasi Saya',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    Expanded(
                      child: _viewModel.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(color: purple),
                            )
                          : _viewModel.errorMessage != null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(25),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: purple,
                                      size: 40,
                                    ),

                                    const SizedBox(height: 10),

                                    const Text(
                                      'Gagal memuat notifikasi',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      _viewModel.errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 11),
                                    ),

                                    const SizedBox(height: 15),

                                    ElevatedButton(
                                      onPressed: () {
                                        _viewModel.fetchNotifications();
                                      },
                                      child: const Text('Coba Lagi'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              color: purple,
                              onRefresh: _viewModel.fetchNotifications,
                              child: ListView(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                ),
                                children: [
                                  buildAntreanNotifications(),
                                  buildJadwalNotifications(),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
