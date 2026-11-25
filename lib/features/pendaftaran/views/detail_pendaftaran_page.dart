
import 'dart:convert';
import '../../antrean/repositories/antrean_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/auth_service.dart';
import 'pendaftaran_berhasil_page.dart';

class DetailPendaftaranPage extends StatefulWidget {
  final Map<String, dynamic> peserta;
  final Map<String, dynamic> jadwal;
  final String tanggal;
  final String waktu;

  const DetailPendaftaranPage({
    super.key,
    required this.peserta,
    required this.jadwal,
    required this.tanggal,
    required this.waktu,
  });

  @override
  State<DetailPendaftaranPage> createState() =>
      _DetailPendaftaranPageState();
}

class _DetailPendaftaranPageState
    extends State<DetailPendaftaranPage> {
  bool _isSubmitting = false;

  String get _namaPeserta =>
      (widget.peserta['nama'] ?? 'Peserta').toString();

  String get _kategori =>
      (widget.peserta['kategori'] ?? '').toString().toUpperCase();

  String get _keteranganKategori {
    final lahir = DateTime.tryParse(
      widget.peserta['tanggalLahir']?.toString() ?? '',
    );

    int? usia;

    if (lahir != null) {
      final hariIni = DateTime.now();

      usia = hariIni.year - lahir.year;

      if (hariIni.month < lahir.month ||
          (hariIni.month == lahir.month &&
              hariIni.day < lahir.day)) {
        usia--;
      }
    }

    final usiaKehamilan =
        widget.peserta['usiaKehamilan']?.toString();

    return switch (_kategori) {
      'BALITA' =>
        usia == null ? 'Balita' : 'Balita $usia Tahun',
      'IBU_HAMIL' =>
        usiaKehamilan == null || usiaKehamilan.isEmpty
            ? 'Ibu Hamil'
            : 'Ibu Hamil $usiaKehamilan',
      'LANSIA' =>
        usia == null ? 'Lansia' : 'Lansia $usia Tahun',
      _ => 'Peserta',
    };
  }

  String get _layanan => switch (_kategori) {
    'BALITA' => 'Pelayanan Balita',
    'IBU_HAMIL' => 'Pelayanan Ibu Hamil',
    'LANSIA' => 'Pelayanan Lansia',
    _ => 'Pelayanan Posyandu',
  };

  String get _avatarPeserta => switch (_kategori) {
    'BALITA' => 'assets/images/avatar_raka.png',
    'IBU_HAMIL' => 'assets/images/avatar_siti.png',
    'LANSIA' => 'assets/images/avatar_sari.png',
    _ => 'assets/images/avatar_4.png',
  };

  String? get _ikonLayanan => switch (_kategori) {
    'BALITA' => 'assets/images/icon_balita_pendaftaran.png',
    'IBU_HAMIL' => 'assets/images/icon_ibuhamil.png',
    'LANSIA' => 'assets/images/icon_lansia_pendaftaran.png',
    _ => null,
  };

  // =====================================================
  // DAFTAR ANTREAN KE BACKEND
  // =====================================================

  Future<void> _daftarkanAntrean() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Ambil ID dari data peserta dan jadwal
      final pesertaId = widget.peserta['id'];
      final jadwalId = widget.jadwal['id'];

      // Body request
      final requestBody = {
        'pesertaId': pesertaId,
        'jadwalId': jadwalId,
      };

      // =================================================
      // DEBUG REQUEST
      // =================================================

      debugPrint('====================================');
      debugPrint('DEBUG BOOKING PELITA');
      debugPrint('PESERTA ID: $pesertaId');
      debugPrint('JADWAL ID: $jadwalId');
      debugPrint('REQUEST BODY: ${jsonEncode(requestBody)}');
      debugPrint('====================================');

      // Kirim request ke backend
      final response = await AuthService.client
          .post(
            Uri.parse('${AuthService.baseUrl}/antrean'),
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 20));

      // =================================================
      // DEBUG RESPONSE
      // =================================================

      debugPrint('HTTP STATUS: ${response.statusCode}');
      debugPrint('RESPONSE BODY: ${response.body}');
      debugPrint('====================================');

      final responseData =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 201 ||
          responseData['success'] != true) {
        throw Exception(
          responseData['message'] ??
              'Pendaftaran antrean gagal.',
        );
      }

      // Ambil data antrean dari backend
      final antrean =
          Map<String, dynamic>.from(responseData['data'] as Map);

      final nomorAntrean = antrean['noAntrean'];
      final antreanId = antrean['id'];

      if (nomorAntrean == null || antreanId == null) {
        throw const FormatException(
          'Data antrean dari server tidak lengkap.',
        );
      }
      // SIMPAN ID ANTREAN AGAR BISA DIBUKA DARI HOME
await AntreanRepository().simpanAntreanId(antreanId.toString());

      // =================================================
      // NAVIGASI KE HALAMAN BERHASIL
      // =================================================

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PendaftaranBerhasilPage(
            namaPeserta: _namaPeserta,
            kategori: _kategori,
            keteranganKategori: _keteranganKategori,
            tanggal: widget.tanggal,
            waktu: widget.waktu,
            lokasi: (widget.jadwal['lokasi'] ?? '').toString(),
            nomorAntrean:
                'A-${nomorAntrean.toString().padLeft(2, '0')}',
            antreanId: antreanId.toString(),
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      debugPrint('ERROR BOOKING: $error');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst('Exception: ', ''),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // =====================================================
  // BUILD UI
  // =====================================================

  @override
  Widget build(BuildContext context) {
    const ungu = Color(0xFFD24BD8);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
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

                        const SizedBox(height: 24),

                        // JUDUL
                        Center(
                          child: Text(
                            'Detail Pendaftaran',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        // KARTU PESERTA
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(
                              color: const Color(0xFF555555),
                              width: 0.9,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 34,
                                backgroundColor:
                                    const Color(0xFFF2F2F2),
                                backgroundImage:
                                    AssetImage(_avatarPeserta),
                              ),

                              const SizedBox(width: 18),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _namaPeserta,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      _keteranganKategori,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // DETAIL LAYANAN
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(
                              color: const Color(0xFF555555),
                              width: 0.9,
                            ),
                          ),
                          child: Column(
                            children: [
                              _detailRow(
                                icon: Icons.child_care,
                                imagePath: _ikonLayanan,
                                judul: 'Layanan',
                                isi: _layanan,
                              ),

                              const SizedBox(height: 19),

                              _detailRow(
                                icon: Icons.calendar_month_outlined,
                                judul: 'Jadwal',
                                isi:
                                    '${widget.tanggal}\n${widget.waktu}',
                              ),

                              const SizedBox(height: 19),

                              _detailRow(
                                icon: Icons.location_on,
                                judul: 'Lokasi',
                                isi:
                                    (widget.jadwal['lokasi'] ?? '-')
                                        .toString(),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        const SizedBox(height: 18),

                        // INFORMASI
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 17,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF555555),
                              width: 0.9,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: ungu,
                                size: 27,
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  'Data Peserta akan digunakan '
                                  'secara otomatis sesuai dengan '
                                  'informasi yang telah terdaftar.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.black,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        const SizedBox(height: 36),

                        // TOMBOL DAFTAR
                        Container(
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
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(16),
                              onTap: _isSubmitting
                                  ? null
                                  : _daftarkanAntrean,
                              child: Center(
                                child: _isSubmitting
                                    ? const SizedBox(
                                        width: 21,
                                        height: 21,
                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Daftar Posyandu',
                                        style:
                                            GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight:
                                              FontWeight.w600,
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
              ),
            );
          },
        ),
      ),
    );
  }

  // =====================================================
  // DETAIL ROW
  // =====================================================

  Widget _detailRow({
    required IconData icon,
    String? imagePath,
    required String judul,
    required String isi,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 32,
          height: 34,
          child: imagePath != null
              ? Image.asset(
                  imagePath,
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                )
              : Icon(
                  icon,
                  size: 30,
                  color: const Color(0xFFD24BD8),
                ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                judul,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
              Text(
                isi,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
