import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';
import '../models/antrean_model.dart';
import '../repositories/antrean_repository.dart';

class PantauAntreanPage extends StatefulWidget {
  final String? antreanId;

  const PantauAntreanPage({
    super.key,
    this.antreanId,
  });

  @override
  State<PantauAntreanPage> createState() =>
      _PantauAntreanPageState();
}

class _PantauAntreanPageState
    extends State<PantauAntreanPage> {
  final AntreanRepository _repository =
      AntreanRepository();

  AntreanModel? _antrean;
  String? _antreanId;

  bool _loading = true;
  bool _cancelLoading = false;
  bool _refreshing = false;

  String? _error;

  Timer? _timer;

  static const Color pink =
      Color(0xFFD52BB5);

  static const Color purple =
      Color(0xFFAD49C5);

  static const Color border =
      Color(0xFFBDBDBD);

  @override
  void initState() {
    super.initState();

    _loadAntrean();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _loadAntrean(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // =========================================================
  // MEMILIH ANTREAN AKTIF PERTAMA
  // =========================================================

  Future<void> _loadAntrean({
    bool tampilLoading = false,
  }) async {
    if (_refreshing || _cancelLoading || !mounted) return;
    _refreshing = true;

    if (tampilLoading) {
      setState(() => _loading = true);
    }

    try {
      AntreanModel? antreanAktif;
      final idDikirim = widget.antreanId?.trim();

      // Dari halaman Nomor Antrean: gunakan ID dari backend.
      if (idDikirim != null && idDikirim.isNotEmpty) {
        antreanAktif = await _repository.getAntreanById(idDikirim);
        if (antreanAktif == null) {
          throw Exception('Data antrean dengan ID tersebut tidak ditemukan.');
        }
      } else {
        // Dari Dashboard: cari antrean aktif milik akun melalui API.
        final daftarAntreanAktif =
            await _repository.getAntreanAktifMilikAkun();
        if (daftarAntreanAktif.isNotEmpty) {
          antreanAktif = daftarAntreanAktif.first;
        }
      }

      if (!mounted) return;

      if (antreanAktif == null) {
        setState(() {
          _antrean = null;
          _antreanId = null;
          _loading = false;
          _error = null;
        });
        return;
      }

      final terbaru =
          await _repository.refreshStatusAntrean(antreanAktif);

      if (!mounted) return;

      setState(() {
        _antrean = terbaru;
        _antreanId = antreanAktif!.id;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    } finally {
      _refreshing = false;
    }
  }

  // REFRESH
  // =========================================================

  Future<void> _refresh() async {
    await _loadAntrean();
  }

  // =========================================================
  // BATALKAN ANTREAN
  // =========================================================

  Future<void> _batalkanAntrean() async {
    final id = _antreanId;
    if (id == null || id.trim().isEmpty || _cancelLoading) return;

    final konfirmasi = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Antrean?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan antrean ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: pink,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );

    if (konfirmasi != true || !mounted) return;

    _timer?.cancel();
    setState(() => _cancelLoading = true);

    try {
      final response = await AuthService.client.patch(
        Uri.parse('${AuthService.baseUrl}/antrean/$id/status'),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': 'BATAL'}),
      ).timeout(const Duration(seconds: 20));

      Map<String, dynamic>? decoded;
      if (response.body.trim().isNotEmpty) {
        try {
          final parsed = jsonDecode(response.body);
          if (parsed is Map) decoded = Map<String, dynamic>.from(parsed);
        } catch (_) {}
      }

      final berhasil = response.statusCode >= 200 &&
          response.statusCode < 300 &&
          decoded?['success'] != false;

      if (!berhasil) {
        throw Exception(decoded?['message']?.toString() ??
            decoded?['error']?.toString() ??
            'Gagal membatalkan antrean (HTTP ${response.statusCode}).');
      }

      await _repository.hapusAntreanDariDaftar(id);
      if (!mounted) return;

      setState(() {
        _antrean = null;
        _antreanId = null;
        _error = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Antrean berhasil dibatalkan'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membatalkan antrean: '
              '${e.toString().replaceFirst('Exception: ', '')}'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _cancelLoading = false);
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 5), (_) {
          if (mounted && !_cancelLoading) _loadAntrean();
        });
        _loadAntrean();
      }
    }
  }

  // FORMAT NOMOR
  // =========================================================

  String _formatNomor(String nomor) {
    if (nomor.isEmpty || nomor == '-') {
      return '-';
    }

    if (nomor.startsWith('A-')) {
      return nomor;
    }

    final angka = int.tryParse(nomor);

    if (angka != null) {
      return 'A-${angka.toString().padLeft(2, '0')}';
    }

    return nomor;
  }

  // =========================================================
  // STATUS
  // =========================================================

  String _statusText(String status) {
    switch (status.toUpperCase()) {
      case 'MENUNGGU':
        return 'Menunggu dipanggil';

      case 'DIPERIKSA':
        return 'Sedang Dilayani';

      case 'SELESAI':
        return 'Pemeriksaan Selesai';

      case 'BATAL':
        return 'Antrean Dibatalkan';

      default:
        return 'Status Antrean';
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width;

    final horizontal =
        width < 360 ? 20.0 : width < 400 ? 26.0 : 32.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Background pink
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 155,
              child: CustomPaint(
                painter: _HeaderPainter(),
              ),
            ),

            Column(
              children: [
                _header(),

                Expanded(
                  child: _loading
                      ? const Center(
                          child:
                              CircularProgressIndicator(
                            color: pink,
                          ),
                        )
                      : _error != null
                          ? _errorView()
                          : RefreshIndicator(
                              color: pink,
                              onRefresh: _refresh,
                              child:
                                  SingleChildScrollView(
                                physics:
                                    const AlwaysScrollableScrollPhysics(),
                                padding:
                                    EdgeInsets.fromLTRB(
                                  horizontal,
                                  8,
                                  horizontal,
                                  30,
                                ),
                                child: _antrean == null
                                    ? _emptyView()
                                    : _content(),
                              ),
                            ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _header() {
    return SizedBox(
      height: 90,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 25,
              ),
            ),

            const Expanded(
              child: Text(
                'Pantau Antrean',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // EMPTY VIEW
  // =========================================================

  Widget _emptyView() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _ticket('-'),

        const SizedBox(height: 25),

        const Text(
          'Antrean Saya',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Belum ada antrean aktif. '
          'Daftarkan peserta ke jadwal Posyandu '
          'untuk mendapatkan nomor antrean.',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 13,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 22),

        _infoCard(
          Icons.access_time,
          'Estimasi Giliran',
          'Belum tersedia',
        ),

        _infoCard(
          Icons.info_outline,
          'Informasi Antrean',
          'Antrean yang selesai atau dibatalkan '
          'tidak akan ditampilkan lagi.',
        ),
      ],
    );
  }

  // =========================================================
  // ERROR VIEW
  // =========================================================

  Widget _errorView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 45,
            ),

            const SizedBox(height: 12),

            Text(
              _error ?? 'Terjadi kesalahan',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                _loadAntrean(
                  tampilLoading: true,
                );
              },
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // CONTENT
  // =========================================================

  Widget _content() {
    final antrean = _antrean!;

    final nomor =
        _formatNomor(antrean.nomorAntrean);

    final status =
        antrean.status.toUpperCase();

    final sedangDilayani =
        status == 'DIPERIKSA';

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _ticket(nomor),

        const SizedBox(height: 24),

        Text(
          _statusText(status),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        if (sedangDilayani)
          _currentServing(),

        _infoCard(
          Icons.access_time,
          'Estimasi Giliran',
          antrean.estimasi,
        ),

        _infoCard(
          Icons.info_outline,
          'Informasi Antrean',
          'Status antrean diperbarui '
          'secara otomatis setiap 5 detik.',
        ),

        const SizedBox(height: 12),

        _cancelButton(status),

        const SizedBox(height: 25),
      ],
    );
  }

  // =========================================================
  // TICKET
  // =========================================================

  Widget _ticket(String nomor) {
    return SizedBox(
      width: double.infinity,
      height: 145,
      child: CustomPaint(
        painter: _TicketPainter(),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Text(
              'Nomor Antrean Anda',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 6),

            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                nomor,
                style: const TextStyle(
                  fontSize: 49,
                  fontWeight: FontWeight.w900,
                  color: purple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // CURRENT SERVING
  // =========================================================

  Widget _currentServing() {
    final antrean = _antrean!;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 18,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Sedang Dilayani',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black87,
                  ),
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: Text(
                  _formatNomor(
                    antrean.nomorSedangDilayani,
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  antrean.layanan,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // INFO CARD
  // =========================================================

  Widget _infoCard(
    IconData icon,
    String title,
    String description,
  ) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 76,
      ),
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: border,
          width: 0.8,
        ),
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: purple,
            size: 24,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // CANCEL BUTTON
  // =========================================================

  Widget _cancelButton(String status) {
    final bolehBatal =
        status == 'MENUNGGU';

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: bolehBatal &&
                !_cancelLoading
            ? _batalkanAntrean
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: pink,
          disabledBackgroundColor:
              Colors.grey.shade400,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(13),
          ),
          elevation: 0,
        ),
        child: _cancelLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                status == 'DIPERIKSA'
                    ? 'Sedang Dilayani'
                    : 'Batalkan Antrean',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}

// =========================================================
// HEADER WAVE
// =========================================================

class _HeaderPainter
    extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.72)
      ..cubicTo(
        size.width * 0.82,
        size.height * 0.62,
        size.width * 0.65,
        size.height * 0.85,
        size.width * 0.45,
        size.height * 0.74,
      )
      ..cubicTo(
        size.width * 0.24,
        size.height * 0.60,
        size.width * 0.10,
        size.height * 0.86,
        0,
        size.height * 0.70,
      )
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..shader =
            const LinearGradient(
          colors: [
            Color(0xFFE84B8D),
            Color(0xFFD42CC2),
            Color(0xFFCE2BCF),
          ],
        ).createShader(rect),
    );

    final wave = Path()
      ..moveTo(0, size.height * 0.32)
      ..cubicTo(
        size.width * 0.30,
        size.height * 0.50,
        size.width * 0.48,
        size.height * 0.32,
        size.width * 0.70,
        size.height * 0.42,
      )
      ..cubicTo(
        size.width * 0.85,
        size.height * 0.50,
        size.width * 0.95,
        size.height * 0.42,
        size.width,
        size.height * 0.34,
      )
      ..lineTo(size.width, size.height * 0.65)
      ..cubicTo(
        size.width * 0.75,
        size.height * 0.65,
        size.width * 0.60,
        size.height * 0.70,
        size.width * 0.40,
        size.height * 0.78,
      )
      ..cubicTo(
        size.width * 0.20,
        size.height * 0.83,
        size.width * 0.10,
        size.height * 0.72,
        0,
        size.height * 0.63,
      )
      ..close();

    canvas.drawPath(
      wave,
      Paint()
        ..color =
            const Color(0xFFFF8FD1)
                .withValues(alpha: 0.4),
    );
  }

  @override
  bool shouldRepaint(
    covariant _HeaderPainter oldDelegate,
  ) {
    return false;
  }
}

// =========================================================
// TICKET PAINTER
// =========================================================

class _TicketPainter
    extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final width = size.width;
    final height = size.height;
    final middle = height / 2;

    const radius = 12.0;
    const notch = 10.0;

    final path = Path()
      ..moveTo(radius, 0)
      ..lineTo(width - radius, 0)
      ..quadraticBezierTo(
        width,
        0,
        width,
        radius,
      )
      ..lineTo(
        width,
        middle - notch,
      )
      ..arcToPoint(
        Offset(width, middle + notch),
        radius: const Radius.circular(notch),
        clockwise: false,
      )
      ..lineTo(
        width,
        height - radius,
      )
      ..quadraticBezierTo(
        width,
        height,
        width - radius,
        height,
      )
      ..lineTo(radius, height)
      ..quadraticBezierTo(
        0,
        height,
        0,
        height - radius,
      )
      ..lineTo(
        0,
        middle + notch,
      )
      ..arcToPoint(
        Offset(0, middle - notch),
        radius: const Radius.circular(notch),
        clockwise: false,
      )
      ..lineTo(0, radius)
      ..quadraticBezierTo(
        0,
        0,
        radius,
        0,
      )
      ..close();

    canvas.drawShadow(
      path,
      Colors.black26,
      2,
      false,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black87
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(
    covariant _TicketPainter oldDelegate,
  ) {
    return false;
  }
}