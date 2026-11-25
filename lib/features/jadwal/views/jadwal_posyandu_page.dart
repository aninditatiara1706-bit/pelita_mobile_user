import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/jadwal_model.dart';
import '../repositories/jadwal_repository.dart';
import '../viewmodels/jadwal_viewmodel.dart';
import '../../pendaftaran/views/detail_pendaftaran_page.dart';

class JadwalPosyanduPage extends StatefulWidget {
  final String pesertaId;
  final String namaPeserta;

  const JadwalPosyanduPage({
    super.key,
    required this.pesertaId,
    required this.namaPeserta,
  });

  @override
  State<JadwalPosyanduPage> createState() =>
      _JadwalPosyanduPageState();
}

class _JadwalPosyanduPageState
    extends State<JadwalPosyanduPage> {
  late final JadwalViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = JadwalViewModel(
      repository: JadwalRepository(),
    );

    _viewModel.muatJadwal();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,

          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  const SizedBox(height: 12),

                  // =================================
                  // TOMBOL KEMBALI
                  // =================================

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

                  const SizedBox(height: 20),

                  // =================================
                  // JUDUL
                  // =================================

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

                  const SizedBox(height: 32),

                  // =================================
                  // SUBJUDUL
                  // =================================

                  Text(
                    'Jadwal yang Tersedia',

                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // =================================
                  // DAFTAR JADWAL
                  // =================================

                  Expanded(
                    child: _buildDaftarJadwal(),
                  ),

                  const SizedBox(height: 16),

                  // =================================
                  // TOMBOL LANJUTKAN
                  // =================================

                  _buildTombolLanjutkan(),

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
  // DAFTAR JADWAL
  // ================================================

  Widget _buildDaftarJadwal() {
    if (_viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFD43BDE),
        ),
      );
    }

    if (_viewModel.errorMessage != null) {
      return Center(
        child: Text(
          _viewModel.errorMessage!,

          textAlign: TextAlign.center,

          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.red,
          ),
        ),
      );
    }

    if (_viewModel.jadwal.isEmpty) {
      return Center(
        child: Text(
          'Belum ada jadwal Posyandu tersedia',

          textAlign: TextAlign.center,

          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,

      itemCount: _viewModel.jadwal.length,

      itemBuilder: (context, index) {
        return _buildJadwalCard(
          _viewModel.jadwal[index],
          index,
        );
      },
    );
  }

  // ================================================
  // KARTU JADWAL
  // ================================================

  Widget _buildJadwalCard(
    JadwalPosyandu jadwal,
    int index,
  ) {
    final selected =
        _viewModel.selectedJadwal == index;

    return GestureDetector(
      onTap: () {
  if (jadwal.penuh) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kuota jadwal ini sudah penuh'),
      ),
    );
    return;
  }

  _viewModel.pilihJadwal(index);
},

      child: Container(
        width: double.infinity,

        margin: const EdgeInsets.only(
          bottom: 14,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(17),

          border: Border.all(
            color: selected
                ? const Color(0xFFD43BDE)
                : const Color(0xFF555555),

            width: selected ? 1.5 : 0.9,
          ),
        ),

        child: Row(
          children: [
            // ICON

            const Icon(
              Icons.calendar_month_outlined,
              color: Color(0xFFD43BDE),
              size: 34,
            ),

            const SizedBox(width: 16),

            // INFORMASI

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  // TANGGAL

                  Text(
                    jadwal.tanggal,

                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // WAKTU

                  Text(
                    jadwal.waktu,

                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // LOKASI

                  Text(
                    jadwal.lokasi,

                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

const SizedBox(height: 5),

Row(
  children: [
    Icon(
      jadwal.penuh
          ? Icons.people_alt_outlined
          : Icons.people_outline,
      size: 14,
      color: jadwal.penuh
          ? Colors.red
          : const Color(0xFFD43BDE),
    ),

    const SizedBox(width: 5),

    Text(
      'Kuota: ${jadwal.informasiKuota}',
      style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: jadwal.penuh
            ? Colors.red
            : const Color(0xFFD43BDE),
      ),
    ),

    if (jadwal.penuh) ...[
      const SizedBox(width: 5),
      Text(
        '(Penuh)',
        style: GoogleFonts.poppins(
          fontSize: 10,
          color: Colors.red,
        ),
      ),
    ],
  ],
),
            const SizedBox(width: 10),

            // RADIO

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

                        decoration:
                            const BoxDecoration(
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

  // ================================================
  // TOMBOL LANJUTKAN
  // ================================================

  Widget _buildTombolLanjutkan() {
    return Container(
      width: double.infinity,
      height: 52,

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF9148D8),
            Color(0xFFE0468F),
          ],
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

          onTap: _lanjutkan,

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
    );
  }

  // ================================================
  // LANJUT KE DETAIL PENDAFTARAN
  // ================================================

  void _lanjutkan() {
    final jadwal =
        _viewModel.jadwalTerpilih;

    if (jadwal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Silakan pilih jadwal terlebih dahulu',
          ),
        ),
      );

      return;
    }

    // DEBUG

    debugPrint('====================================');
    debugPrint('BOOKING PELITA');
    debugPrint('PESERTA ID: ${widget.pesertaId}');
    debugPrint('NAMA PESERTA: ${widget.namaPeserta}');
    debugPrint('JADWAL ID: ${jadwal.id}');
    debugPrint('TANGGAL: ${jadwal.tanggal}');
    debugPrint('WAKTU: ${jadwal.waktu}');
    debugPrint('LOKASI: ${jadwal.lokasi}');
    debugPrint('====================================');

    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) =>
            DetailPendaftaranPage(
          peserta: {
            'id': widget.pesertaId,
            'nama': widget.namaPeserta,
          },

          jadwal: {
            'id': jadwal.id,
            'tanggal': jadwal.tanggal,
            'waktu': jadwal.waktu,
            'lokasi': jadwal.lokasi,
          },

          tanggal: jadwal.tanggal,
          waktu: jadwal.waktu,
        ),
      ),
    );
  }
}