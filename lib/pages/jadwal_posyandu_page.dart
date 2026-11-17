import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/auth_service.dart';
import 'detail_pendaftaran_page.dart';

class JadwalPosyanduPage extends StatefulWidget {
  final Map<String, dynamic> peserta;

  const JadwalPosyanduPage({super.key, required this.peserta});

  @override
  State<JadwalPosyanduPage> createState() => _JadwalPosyanduPageState();
}

class _JadwalPosyanduPageState extends State<JadwalPosyanduPage> {
  int _selectedJadwal = 0;
  List<Map<String, dynamic>> _jadwal = [];
  bool _isLoading = true;
  String? _error;

  static const _bulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  @override
  void initState() {
    super.initState();
    _loadJadwal();
  }

  Future<void> _loadJadwal() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await AuthService.client
          .get(Uri.parse('${AuthService.baseUrl}/jadwal'))
          .timeout(const Duration(seconds: 15));
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 || responseData['success'] != true) {
        throw Exception(
          responseData['message'] ?? 'Gagal memuat jadwal Posyandu.',
        );
      }

      final data = responseData['data'];
      if (data is! List) {
        throw const FormatException('Format daftar jadwal tidak valid.');
      }

      final now = DateTime.now();
final today = DateTime(now.year, now.month, now.day);

final jadwal = data
    .whereType<Map>()
    .map((item) => Map<String, dynamic>.from(item))
    .where((item) {
      if (item['status'] == 'SELESAI') return false;

      final tanggal = DateTime.parse(
        item['tanggal'].toString(),
      ).toLocal();

      final tanggalJadwal = DateTime(
        tanggal.year,
        tanggal.month,
        tanggal.day,
      );

      return !tanggalJadwal.isBefore(today);
    })
    .toList();

      if (!mounted) return;
      setState(() {
        _jadwal = jadwal;
        _selectedJadwal = 0;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  DateTime _tanggalJadwal(Map<String, dynamic> jadwal) {
    final tanggal = jadwal['tanggal'];
    if (tanggal is DateTime) return tanggal.toLocal();
    return DateTime.parse(tanggal.toString()).toLocal();
  }

  String _formatTanggal(Map<String, dynamic> jadwal) {
    final tanggal = _tanggalJadwal(jadwal);
    return '${tanggal.day} ${_bulan[tanggal.month - 1]} ${tanggal.year}';
  }

  String _formatWaktu(Map<String, dynamic> jadwal) {
    final tanggal = _tanggalJadwal(jadwal);
    final jam = tanggal.hour.toString().padLeft(2, '0');
    final menit = tanggal.minute.toString().padLeft(2, '0');
    return '$jam.$menit WIB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // TOMBOL KEMBALI
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 28),

              Center(
                child: Text(
                  'Jadwal Posyandu',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 46),

              Text(
                'Jadwal yang Tersedia',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 14),

              Expanded(child: _buildDaftarJadwal()),

              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9148D8), Color(0xFFE0468F)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF282028),
                    width: 0.8,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _jadwal.isEmpty || _isLoading || _error != null
                        ? null
                        : () {
                            final jadwal = _jadwal[_selectedJadwal];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPendaftaranPage(
                                  peserta: widget.peserta,
                                  jadwal: jadwal,
                                  tanggal: _formatTanggal(jadwal),
                                  waktu: _formatWaktu(jadwal),
                                ),
                              ),
                            );
                          },

                    child: Center(
                      child: Text(
                        'Lanjutkan',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDaftarJadwal() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Gagal memuat jadwal\n$_error', textAlign: TextAlign.center),
            TextButton(onPressed: _loadJadwal, child: const Text('Coba lagi')),
          ],
        ),
      );
    }

    if (_jadwal.isEmpty) {
      return Center(
        child: Text(
          'Belum ada jadwal Posyandu yang tersedia.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      itemCount: _jadwal.length,
      itemBuilder: (context, index) => _buildJadwalCard(index),
    );
  }

  Widget _buildJadwalCard(int index) {
    final jadwal = _jadwal[index];
    final selected = _selectedJadwal == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedJadwal = index;
        });
      },
      child: Container(
        width: double.infinity,
        height: 104,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFF555555), width: 0.9),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month_outlined,
              color: Color(0xFFD43BDE),
              size: 34,
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatTanggal(jadwal),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatWaktu(jadwal),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xFFD43BDE)
                      : const Color(0xFF555555),
                  width: 1.4,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD43BDE),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
