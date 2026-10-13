
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  static const Color purple = Color(0xFFD04CD7);

  Widget notificationItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 4,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: purple,
            width: 2.5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: purple,
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tombol kembali
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    left: 12,
                  ),
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

                // Judul halaman
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
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    children: [
                      notificationItem(
                        icon: Icons.access_time_outlined,
                        title: 'Antrean Anda hampir tiba',
                        description:
                            'Antrean Budi Santoso segera dipanggil.\n'
                            'No. A-012 • Sekitar 30 menit lagi\n'
                            'Sedang dilayani: A-009',
                      ),

                      notificationItem(
                        icon: Icons.calendar_month_outlined,
                        title: 'Jadwal Posyandu Hari Ini',
                        description:
                            'Posyandu Melati • 08.00–11.00 WIB\n'
                            'Jangan lupa datang sesuai jadwal ya!',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
