import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'nomor_antrean_page.dart';

class PendaftaranBerhasilPage extends StatelessWidget {
  final String namaPeserta;
  final String tanggal;
  final String waktu;

  const PendaftaranBerhasilPage({
    super.key,
    required this.namaPeserta,
    required this.tanggal,
    required this.waktu,
  });

  @override
  Widget build(BuildContext context) {
    final isRaka = namaPeserta.toLowerCase() == 'raka';

    final keterangan = isRaka
    ? 'Balita 3 Tahun'
    : 'Lansia 65 Tahun';

    final gambar = isRaka
        ? 'assets/images/avatar_raka.png'
        : 'assets/images/avatar_sari.png';

    final layanan = isRaka
        ? 'Pelayanan Balita'
        : 'Pelayanan Lansia';

    final iconLayanan = isRaka
        ? 'assets/images/icon_balita_pendaftaran.png'
        : 'assets/images/icon_lansia_pendaftaran.png';

    const pink = Color(0xFFD24BD8);

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
                    padding: const EdgeInsets.fromLTRB(
                      24, 22, 24, 24,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        // ANIMASI CENTANG BERHASIL
                        const AnimatedSuccessCheck(),

                        const SizedBox(height: 12),

                        Text(
                          'Pendaftaran Berhasil!',
                          style: GoogleFonts.poppins(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          'Peserta Anda telah terdaftar\n'
                          'untuk pelayanan Posyandu.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(17),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(17),
                            border: Border.all(
                              color: const Color(0xFF555555),
                              width: 0.9,
                            ),
                          ),
                          child: Column(
                            children: [

                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor:
                                        const Color(0xFFF2F2F2),
                                    backgroundImage:
                                        AssetImage(gambar),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          namaPeserta,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight:
                                                FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          keterangan,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              _infoRow(
                                icon: Image.asset(
                                  iconLayanan,
                                  width: 29,
                                  height: 29,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) =>
                                      const Icon(
                                    Icons.people,
                                    color: pink,
                                    size: 29,
                                  ),
                                ),
                                judul: 'Layanan',
                                isi: layanan,
                              ),

                              const SizedBox(height: 18),

                              _infoRow(
                                icon: const Icon(
                                  Icons.calendar_month_outlined,
                                  size: 30,
                                  color: pink,
                                ),
                                judul: 'Jadwal',
                                isi: '$tanggal\n$waktu',
                              ),

                              const SizedBox(height: 18),

                              _infoRow(
                                icon: const Icon(
                                  Icons.location_on,
                                  size: 30,
                                  color: pink,
                                ),
                                judul: 'Lokasi',
                                isi: 'Posyandu Melati',
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),
                        const SizedBox(height: 30),

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
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(16),
                              
onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NomorAntreanPage(
        tanggal: tanggal,
        waktu: waktu,
        namaPeserta: namaPeserta,
        nomorAntrean: 'A-12',
        namaPosyandu: 'Posyandu Rw 03',
      ),
    ),
  );
},

                              child: Center(
                                child: Text(
                                  'Ambil Nomor Antrean',
                                  style: GoogleFonts.poppins(
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

  Widget _infoRow({
    required Widget icon,
    required String judul,
    required String isi,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 32,
          height: 34,
          child: Center(child: icon),
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
                  height: 1.35,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AnimatedSuccessCheck extends StatefulWidget {
  const AnimatedSuccessCheck({super.key});

  @override
  State<AnimatedSuccessCheck> createState() =>
      _AnimatedSuccessCheckState();
}

class _AnimatedSuccessCheckState
    extends State<AnimatedSuccessCheck>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final nilai = _controller.value;

        final bounce = ((nilai - 0.70) / 0.30)
            .clamp(0.0, 1.0)
            .toDouble();

        final scale =
            0.94 + 0.06 * Curves.elasticOut.transform(bounce);

        return Transform.scale(
          scale: scale,
          child: CustomPaint(
            size: const Size(140, 140),
            painter: _SuccessCheckPainter(
              progress: nilai,
            ),
          ),
        );
      },
    );
  }
}

class _SuccessCheckPainter extends CustomPainter {
  final double progress;

  _SuccessCheckPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    const radius = 53.0;

    final circleProgress =
        (progress / 0.55).clamp(0.0, 1.0).toDouble();

    final circlePaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF7F3DB8),
          Color(0xFFE0468F),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      -math.pi / 2,
      2 * math.pi * circleProgress,
      false,
      circlePaint,
    );

    if (progress <= 0.55) return;

    final checkProgress =
        ((progress - 0.55) / 0.35)
            .clamp(0.0, 1.0)
            .toDouble();

    final checkPaint = Paint()
      ..color = const Color(0xFF64328F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final start = Offset(
      center.dx - 24,
      center.dy + 1,
    );

    final middle = Offset(
      center.dx - 6,
      center.dy + 18,
    );

    final end = Offset(
      center.dx + 31,
      center.dy - 26,
    );

    final firstPart =
        (checkProgress / 0.4).clamp(0.0, 1.0).toDouble();

    canvas.drawLine(
      start,
      Offset.lerp(start, middle, firstPart)!,
      checkPaint,
    );

    if (checkProgress > 0.4) {
      final secondPart =
          ((checkProgress - 0.4) / 0.6)
              .clamp(0.0, 1.0)
              .toDouble();

      canvas.drawLine(
        middle,
        Offset.lerp(middle, end, secondPart)!,
        checkPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SuccessCheckPainter old) {
    return old.progress != progress;
  }
}


