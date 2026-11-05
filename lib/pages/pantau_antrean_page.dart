import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PantauAntreanPage extends StatelessWidget {
  final String nomorAntrean;
  final String namaPeserta;

  const PantauAntreanPage({
    super.key,
    required this.nomorAntrean,
    required this.namaPeserta,
  });

  @override
  Widget build(BuildContext context) {
    final isLansia = namaPeserta.toLowerCase() == 'sari';

    final layanan = isLansia
        ? 'Pemeriksaan Lansia'
        : 'Pemeriksaan Balita';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 185,
            child: CustomPaint(
              painter: _PantauWavePainter(),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        30, 8, 30, 28,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          
                    Row(
                      children: [
                        SizedBox(
                          width: 48,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 28,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/dashboard',
                                (route) => false,
                              );
                            },
                          ),
                        ),

                        Expanded(
                          child: Text(
                            'Pantau Antrean',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(width: 48),
                      ],
                    ),

                    const SizedBox(height: 52),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: CustomPaint(
                              painter: _PantauTicketPainter(),
                              child: SizedBox(
                                width: double.infinity,
                                height: 160,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Nomor Antrean Anda',
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight:
                                            FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    ShaderMask(
                                      shaderCallback: (bounds) {
                                        return const LinearGradient(
                                          colors: [
                                            Color(0xFFB345D6),
                                            Color(0xFFE04FBC),
                                          ],
                                        ).createShader(bounds);
                                      },
                                      blendMode: BlendMode.srcIn,
                                      child: Text(
                                        nomorAntrean,
                                        style: GoogleFonts.poppins(
                                          fontSize: 60,
                                          fontWeight:
                                              FontWeight.w800,
                                          height: 1.1,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 36),

                          Text(
                            'Sedang Dilayani',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [

                              CustomPaint(
                                painter: _PantauTicketPainter(
                                  radius: 7,
                                  notchRadius: 6,
                                  strokeWidth: 1,
                                ),
                                child: SizedBox(
                                  width: 94,
                                  height: 57,
                                  child: Center(
                                    child: Text(
                                      'A-08',
                                      style: GoogleFonts.poppins(
                                        fontSize: 25,
                                        fontWeight:
                                            FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  layanan,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 34),

                          _buildInfoCard(
                            icon: Icons.access_time_outlined,
                            text:
                                'Estimasi Giliran\n'
                                'Sekitar 40 Menit Lagi',
                          ),

                          const SizedBox(height: 14),

                          _buildInfoCard(
                            icon: Icons.info_outline,
                            text:
                                'Kami akan memberi tahu\n'
                                'Anda Saat nomor antrean\n'
                                'mendekati',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 78,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF444444),
          width: 0.9,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFD54DDD),
            size: 29,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
  fontSize: 13,
  height: 1.5,
  fontWeight: FontWeight.w400,
  color: const Color(0xFF333333),
),
            ),
          ),
        ],
      ),
    );
  }
}

class _PantauWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final rect = Rect.fromLTWH(0, 0, w, h);

    final dasar = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h * 0.75)
      ..cubicTo(
        w * 0.85, h * 0.59,
        w * 0.72, h * 0.40,
        w * 0.53, h * 0.49,
      )
      ..cubicTo(
        w * 0.34, h * 0.60,
        w * 0.20, h * 0.76,
        0, h * 0.58,
      )
      ..close();

    canvas.drawPath(
      dasar,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE74C82),
            Color(0xFFD72BC5),
            Color(0xFFD52FD0),
          ],
        ).createShader(rect),
    );

    final atas = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..cubicTo(
        w * 0.77, h * 0.10,
        w * 0.62, h * 0.28,
        w * 0.40, h * 0.28,
      )
      ..cubicTo(
        w * 0.23, h * 0.28,
        w * 0.10, h * 0.22,
        0, h * 0.20,
      )
      ..close();

    canvas.drawPath(
      atas,
      Paint()
        ..color = const Color(0xFFAF21AC)
            .withValues(alpha: 0.45),
    );

    final tengah = Path()
      ..moveTo(0, h * 0.30)
      ..cubicTo(
        w * 0.23, h * 0.43,
        w * 0.37, h * 0.45,
        w * 0.58, h * 0.32,
      )
      ..cubicTo(
        w * 0.77, h * 0.20,
        w * 0.88, h * 0.19,
        w, h * 0.24,
      )
      ..lineTo(w, h * 0.46)
      ..cubicTo(
        w * 0.75, h * 0.37,
        w * 0.61, h * 0.43,
        w * 0.43, h * 0.56,
      )
      ..cubicTo(
        w * 0.20, h * 0.67,
        w * 0.11, h * 0.53,
        0, h * 0.44,
      )
      ..close();

    canvas.drawPath(
      tengah,
      Paint()
        ..color = const Color(0xFFFF91D0)
            .withValues(alpha: 0.40),
    );

    final bawah = Path()
      ..moveTo(0, h * 0.48)
      ..cubicTo(
        w * 0.21, h * 0.72,
        w * 0.40, h * 0.62,
        w * 0.61, h * 0.49,
      )
      ..cubicTo(
        w * 0.79, h * 0.36,
        w * 0.89, h * 0.43,
        w, h * 0.51,
      )
      ..lineTo(w, h * 0.75)
      ..cubicTo(
        w * 0.85, h * 0.59,
        w * 0.72, h * 0.40,
        w * 0.53, h * 0.49,
      )
      ..cubicTo(
        w * 0.34, h * 0.60,
        w * 0.20, h * 0.76,
        0, h * 0.58,
      )
      ..close();

    canvas.drawPath(
      bawah,
      Paint()
        ..color = const Color(0xFFF58ED3)
            .withValues(alpha: 0.42),
    );
  }

  @override
  bool shouldRepaint(covariant _PantauWavePainter old) {
    return false;
  }
}

class _PantauTicketPainter extends CustomPainter {
  final double radius;
  final double notchRadius;
  final double strokeWidth;

  _PantauTicketPainter({
    this.radius = 13,
    this.notchRadius = 11,
    this.strokeWidth = 1.3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final middle = h / 2;

    final path = Path()
      ..moveTo(radius, 0)
      ..lineTo(w - radius, 0)
      ..quadraticBezierTo(w, 0, w, radius)
      ..lineTo(w, middle - notchRadius)

      ..arcToPoint(
        Offset(w, middle + notchRadius),
        radius: Radius.circular(notchRadius),
        clockwise: false,
      )
      ..lineTo(w, h - radius)
      ..quadraticBezierTo(w, h, w - radius, h)
      ..lineTo(radius, h)
      ..quadraticBezierTo(0, h, 0, h - radius)
      ..lineTo(0, middle + notchRadius)

      ..arcToPoint(
        Offset(0, middle - notchRadius),
        radius: Radius.circular(notchRadius),
        clockwise: false,
      )
      ..lineTo(0, radius)
      ..quadraticBezierTo(0, 0, radius, 0)
      ..close();

    canvas.drawShadow(
      path,
      const Color(0x33000000),
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
        ..color = const Color(0xFF333333)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }

  @override
  bool shouldRepaint(
    covariant _PantauTicketPainter old,
  ) {
    return old.radius != radius ||
        old.notchRadius != notchRadius ||
        old.strokeWidth != strokeWidth;
  }
}
