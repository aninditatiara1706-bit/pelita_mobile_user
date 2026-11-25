import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/posyandu_model.dart';
import '../repositories/posyandu_repository.dart';
import '../viewmodel/posyandu_viewmodel.dart';
import '../../jadwal/views/jadwal_posyandu_page.dart';

class DaftarPosyanduPage extends StatefulWidget {
  const DaftarPosyanduPage({super.key});

  @override
  State<DaftarPosyanduPage> createState() => _DaftarPosyanduPageState();
}

class _DaftarPosyanduPageState extends State<DaftarPosyanduPage> {
  late final PosyanduViewModel _viewModel;

  // ================================================
  // INIT STATE
  // ================================================

  @override
  void initState() {
    super.initState();

    _viewModel = PosyanduViewModel(repository: PosyanduRepository());

    _viewModel.muatPeserta();
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

                  // ==================================
                  // TOMBOL KEMBALI
                  // ==================================
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

                  // ==================================
                  // JUDUL HALAMAN
                  // ==================================
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

                  // ==================================
                  // JUDUL PILIH PESERTA
                  // ==================================
                  Text(
                    'Pilih Peserta',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ==================================
                  // DAFTAR PESERTA
                  // ==================================
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
                    ...List.generate(_viewModel.peserta.length, (index) {
                      return _buildPesertaCard(
                        _viewModel.peserta[index],
                        index,
                      );
                    }),

                  const Spacer(),

                  // ==================================
                  // TOMBOL LANJUTKAN
                  // ==================================
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
  final peserta = _viewModel.pesertaTerpilih;

  if (peserta == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Silakan pilih peserta terlebih dahulu'),
      ),
    );
    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => JadwalPosyanduPage(
        pesertaId: peserta.id,
        namaPeserta: peserta.nama,
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
  // KARTU PESERTA
  // ================================================

  Widget _buildPesertaCard(PesertaPosyandu peserta, int index) {
    final selected = _viewModel.selectedPeserta == index;

    return GestureDetector(
      onTap: () {
        _viewModel.pilihPeserta(index);
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
            // FOTO PESERTA

            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFFF4EAF6),
              backgroundImage: AssetImage(peserta.gambar),
            ),

            const SizedBox(width: 15),

            // NAMA DAN KETERANGAN
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    peserta.nama,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),

                  Text(
                    peserta.keterangan,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
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
