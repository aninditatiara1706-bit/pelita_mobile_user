import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/jadwal_model.dart';
import '../repositories/jadwal_repository.dart';
import '../viewmodels/jadwal_viewmodel.dart';
import '../../pendaftaran/views/detail_pendaftaran_page.dart';

class JadwalPosyanduPage extends StatefulWidget {
  final String namaPeserta;

  const JadwalPosyanduPage({super.key, required this.namaPeserta});

  @override
  State<JadwalPosyanduPage> createState() => _JadwalPosyanduPageState();
}

class _JadwalPosyanduPageState extends State<JadwalPosyanduPage> {
  late final JadwalViewModel _viewModel;

  // ================================================
  // INIT STATE
  // ================================================

  @override
  void initState() {
    super.initState();

    _viewModel = JadwalViewModel(repository: JadwalRepository());

    _viewModel.muatJadwal();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
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

                  // JUDUL HALAMAN
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

                  // JUDUL JADWAL
                  Text(
                    'Jadwal yang Tersedia',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // DAFTAR JADWAL
                  if (_viewModel.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_viewModel.errorMessage != null)
                    Center(
                      child: Text(
                        _viewModel.errorMessage!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    )
                  else
                    ...List.generate(
                      _viewModel.jadwal.length,
                      (index) =>
                          _buildJadwalCard(_viewModel.jadwal[index], index),
                    ),

                  const Spacer(),

                  // TOMBOL LANJUTKAN
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

                        onTap: () {
                          final jadwal = _viewModel.jadwalTerpilih;

                          if (jadwal == null) {
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPendaftaranPage(
                                peserta: {'nama': widget.namaPeserta},
                                jadwal: {
                                  'tanggal': jadwal.tanggal,
                                  'waktu': jadwal.waktu,
                                },
                                tanggal: jadwal.tanggal,
                                waktu: jadwal.waktu,
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
      },
    );
  }

  // ================================================
  // KARTU JADWAL
  // ================================================

  Widget _buildJadwalCard(JadwalPosyandu jadwal, int index) {
    final selected = _viewModel.selectedJadwal == index;

    return GestureDetector(
      onTap: () {
        _viewModel.pilihJadwal(index);
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
            // IKON KALENDER

            const Icon(
              Icons.calendar_month_outlined,
              color: Color(0xFFD43BDE),
              size: 34,
            ),

            const SizedBox(width: 16),

            // INFORMASI JADWAL
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    jadwal.tanggal,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    jadwal.waktu,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // RADIO BUTTON
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
