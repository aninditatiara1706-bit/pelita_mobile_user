import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/peserta_service.dart';
import 'jadwal_posyandu_page.dart';

class DaftarPosyanduPage extends StatefulWidget {
  const DaftarPosyanduPage({super.key});

  @override
  State<DaftarPosyanduPage> createState() => _DaftarPosyanduPageState();
}

class _DaftarPosyanduPageState extends State<DaftarPosyanduPage> {
  int _selectedPeserta = 0;
  List<Map<String, dynamic>> _peserta = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPeserta();
  }

  Future<void> _loadPeserta() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final peserta = await PesertaService().getMyParticipants();
      if (!mounted) return;

      setState(() {
        _peserta = peserta;
        _selectedPeserta = 0;
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
                  'Daftar Posyandu',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Pilih Peserta',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 14),

              Expanded(child: _buildDaftarPeserta()),

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
                    onTap: _peserta.isEmpty || _isLoading || _error != null
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JadwalPosyanduPage(
                                  peserta: _peserta[_selectedPeserta],
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

  Widget _buildDaftarPeserta() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Gagal memuat peserta\n$_error', textAlign: TextAlign.center),
            TextButton(onPressed: _loadPeserta, child: const Text('Coba lagi')),
          ],
        ),
      );
    }

    if (_peserta.isEmpty) {
      return Center(
        child: Text(
          'Belum ada peserta yang terdaftar pada akun ini.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      itemCount: _peserta.length,
      itemBuilder: (context, index) => _buildPesertaCard(index),
    );
  }

  Widget _buildPesertaCard(int index) {
    final peserta = _peserta[index];
    final selected = _selectedPeserta == index;
    final kategori = (peserta['kategori'] ?? '').toString().toUpperCase();
    final usia = _usiaTahun(peserta['tanggalLahir']);
    final usiaKehamilan = peserta['usiaKehamilan']?.toString();
    final keterangan = switch (kategori) {
      'BALITA' => usia == null ? 'Balita' : 'Balita $usia Tahun',
      'IBU_HAMIL' =>
        usiaKehamilan == null || usiaKehamilan.isEmpty
            ? 'Ibu Hamil'
            : 'Ibu Hamil $usiaKehamilan',
      'LANSIA' => usia == null ? 'Lansia' : 'Lansia $usia Tahun',
      _ => 'Peserta',
    };
    final gambar = switch (kategori) {
      'BALITA' => 'assets/images/avatar_raka.png',
      'IBU_HAMIL' => 'assets/images/avatar_siti.png',
      'LANSIA' => 'assets/images/avatar_sari.png',
      _ => 'assets/images/avatar_4.png',
    };

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeserta = index;
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFF666666), width: 0.9),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFFF2F2F2),
              backgroundImage: AssetImage(gambar),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (peserta['nama'] ?? 'Peserta').toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    keterangan,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
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

  int? _usiaTahun(dynamic tanggalLahir) {
    final lahir = DateTime.tryParse(tanggalLahir?.toString() ?? '');
    if (lahir == null) return null;

    final hariIni = DateTime.now();
    var usia = hariIni.year - lahir.year;
    if (hariIni.month < lahir.month ||
        (hariIni.month == lahir.month && hariIni.day < lahir.day)) {
      usia--;
    }
    return usia;
  }
}
