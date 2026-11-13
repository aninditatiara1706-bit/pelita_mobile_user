import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  static const Color purple = Color(0xFFD04CD7);
  static const String baseUrl = 'http://localhost:4000/api';

  late final BrowserClient _client;

  bool isLoading = true;
  String? errorMessage;

  List<Map<String, dynamic>> antreanSaya = [];
  List<Map<String, dynamic>> jadwalHariIni = [];

  @override
  void initState() {
    super.initState();

    // Mengirim cookie login agar backend mengenali akun pengguna.
    _client = BrowserClient()..withCredentials = true;

    fetchNotifications();
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  // Mengambil data dari backend
  Future<void> fetchNotifications() async {
    try {
      final responses = await Future.wait([
        _client.get(Uri.parse('$baseUrl/antrean/saya')),
        _client.get(Uri.parse('$baseUrl/jadwal')),
      ]);

      final antreanResponse = jsonDecode(responses[0].body);
      final jadwalResponse = jsonDecode(responses[1].body);

      if (responses[0].statusCode != 200) {
        throw Exception(
          antreanResponse['message'] ?? 'Gagal mengambil data antrean',
        );
      }

      if (responses[1].statusCode != 200) {
        throw Exception(
          jadwalResponse['message'] ?? 'Gagal mengambil jadwal',
        );
      }

      final antreanData = antreanResponse['data'] as List? ?? [];
      final jadwalData = jadwalResponse['data'] as List? ?? [];

      final today = DateTime.now();
      final todayString =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final filteredJadwal = jadwalData
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .where((item) {
        final tanggal = item['tanggal']?.toString() ?? '';
        return tanggal.startsWith(todayString);
      }).toList();

      if (!mounted) return;

      setState(() {
        antreanSaya = antreanData
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

        jadwalHariIni = filteredJadwal;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  // Format tanggal
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

  // Format jam
  String formatJam(dynamic value) {
    if (value == null) return '';

    final text = value.toString();

    if (text.contains('T')) {
      return text.substring(11, 16);
    }

    return text.length >= 5 ? text.substring(0, 5) : text;
  }

  // Widget notifikasi
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

  // Notifikasi antrean pengguna
  Widget buildAntreanNotifications() {
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
        final peserta = antrean['peserta'] is Map
            ? Map<String, dynamic>.from(antrean['peserta'])
            : <String, dynamic>{};

        final jadwal = antrean['jadwal'] is Map
            ? Map<String, dynamic>.from(antrean['jadwal'])
            : <String, dynamic>{};

        final namaPeserta = peserta['nama'] ?? 'Peserta';
        final nomorAntrean = antrean['noAntrean'] ?? '-';
        final status = antrean['status'] ?? 'MENUNGGU';

        String statusText;

        switch (status.toString()) {
          case 'DIPERIKSA':
            statusText = 'Sedang dalam pemeriksaan.';
            break;
          case 'MENUNGGU':
            statusText = 'Antrean kamu sedang menunggu dipanggil.';
            break;
          default:
            statusText = 'Status antrean: $status';
        }

        return notificationItem(
          icon: Icons.access_time_outlined,
          title: 'Informasi Antrean Posyandu',
          description:
              'Peserta: $namaPeserta\n'
              'Nomor antrean: $nomorAntrean\n'
              '$statusText\n'
              'Tanggal: ${formatTanggal(jadwal['tanggal'])}',
        );
      }).toList(),
    );
  }

  // Notifikasi jadwal Posyandu hari ini
  Widget buildJadwalNotifications() {
    if (jadwalHariIni.isEmpty) {
      return notificationItem(
        icon: Icons.calendar_month_outlined,
        title: 'Jadwal Posyandu Hari Ini',
        description: 'Belum ada jadwal Posyandu untuk hari ini.',
      );
    }

    return Column(
      children: jadwalHariIni.map((jadwal) {
        final nama = jadwal['namaPosyandu'] ??
            jadwal['nama'] ??
            'Posyandu';

        final jamMulai = formatJam(jadwal['jamMulai']);
        final jamSelesai = formatJam(jadwal['jamSelesai']);

        final waktu = jamMulai.isNotEmpty && jamSelesai.isNotEmpty
            ? '$jamMulai–$jamSelesai WIB'
            : 'Waktu belum tersedia';

        final lokasi = jadwal['lokasi'] ??
            jadwal['alamat'] ??
            '';

        return notificationItem(
          icon: Icons.calendar_month_outlined,
          title: 'Jadwal Posyandu Hari Ini',
          description:
              '$nama • $waktu\n'
              '${lokasi.toString().isNotEmpty ? '$lokasi\n' : ''}'
              'Jangan lupa datang sesuai jadwal ya!',
        );
      }).toList(),
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
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: purple,
                          ),
                        )
                      : errorMessage != null
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
                                      errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                    const SizedBox(height: 15),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          isLoading = true;
                                          errorMessage = null;
                                        });
                                        fetchNotifications();
                                      },
                                      child: const Text('Coba Lagi'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              color: purple,
                              onRefresh: fetchNotifications,
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
  }
}
