import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pantau_antrean_page.dart';

class NomorAntreanPage extends StatelessWidget {
  final String tanggal;
  final String waktu;
  final String namaPeserta;

  final String nomorAntrean;
  final String namaPosyandu;

  const NomorAntreanPage({
  super.key,
  required this.tanggal,
  required this.waktu,
  required this.namaPeserta,
  this.nomorAntrean = 'A-12',
  this.namaPosyandu = 'Posyandu Rw 03',
});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 215,
            child: CustomPaint(
              painter: _PinkWavePainter(),
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
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                         
const SizedBox(height: 8),

Padding(
  padding: const EdgeInsets.symmetric(horizontal: 30),
  child: Row(
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
            Navigator.pop(context);
          },
        ),
      ),
      Expanded(
        child: Text(
          'Nomor Antrean',
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
),

const SizedBox(height: 52),

 Center(
   child: SizedBox(
     width: MediaQuery.sizeOf(context).width * 0.78,
     child: _buildTicket(),
   ),
 ),


                          const SizedBox(height: 30),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 36,
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                _detailText(namaPosyandu),
                                const SizedBox(height: 12),
                                _detailText(tanggal),
                                const SizedBox(height: 12),
                                _detailText(waktu),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 30,
                            ),
                            child: Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color:
                                      const Color(0xFF4C4C4C),
                                  width: 0.9,
                                ),
                                borderRadius:
                                    BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Simpan Nomor ini dan pantau\n'
                                'status antrian anda',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
  fontSize: 13,
  height: 1.5,
  color: const Color(0xFF333333),
),
                              ),
                            ),
                          ),

                          const Spacer(),

                          const SizedBox(height: 28),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 30,
                            ),
                            child: _buildGradientButton(
                              title: 'Pantau Nomor Antrean',
                              onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PantauAntreanPage(
        nomorAntrean: nomorAntrean,
        namaPeserta: namaPeserta,
      ),
    ),
  );
},
                            ),
                          ),

                          const SizedBox(height: 9),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 30,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 46,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  side: const BorderSide(
                                    color: Color(0xFF333333),
                                    width: 1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/dashboard',
                                    (route) => false,
                                  );
                                },
                                child: Text(
                                  'Kembali ke Home',
                                  style: GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: const Color(0xFF333333),
),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),
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

  Widget _buildTicket() {
    return CustomPaint(
      painter: _TicketPainter(),
      child: SizedBox(
        width: double.infinity,
        height: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nomor Antrean Anda',
              style: GoogleFonts.poppins(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: Colors.black,
),
            ),

            const SizedBox(height: 4),

            ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [
                    Color(0xFFAD4CDA),
                    Color(0xFFE050AF),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcIn,
              child: Text(
                nomorAntrean,
                style: GoogleFonts.poppins(
                  fontSize: 65,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailText(String text) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        text,
        style: GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: const Color(0xFF333333),
),
      ),
    );
  }

  Widget _buildGradientButton({
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 46,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF9345D1),
            Color(0xFFE04492),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PinkWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final bounds = Rect.fromLTWH(0, 0, w, h);

    final backgroundPath = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h * 0.76)
      ..cubicTo(
        w * 0.82, h * 0.59,
        w * 0.76, h * 0.39,
        w * 0.53, h * 0.48,
      )
      ..cubicTo(
        w * 0.32, h * 0.56,
        w * 0.19, h * 0.77,
        0, h * 0.59,
      )
      ..close();

    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFE84D83),
          Color(0xFFD52ACA),
          Color(0xFFD934CA),
        ],
      ).createShader(bounds);

    canvas.drawPath(backgroundPath, backgroundPaint);

    final upperWave = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..cubicTo(
        w * 0.75, h * 0.10,
        w * 0.61, h * 0.23,
        w * 0.43, h * 0.25,
      )
      ..cubicTo(
        w * 0.26, h * 0.29,
        w * 0.12, h * 0.21,
        0, h * 0.20,
      )
      ..close();

    canvas.drawPath(
      upperWave,
      Paint()
        ..color = const Color(0xFFB927AC)
            .withValues(alpha: 0.36),
    );

    final middleWave = Path()
      ..moveTo(0, h * 0.30)
      ..cubicTo(
        w * 0.23, h * 0.45,
        w * 0.37, h * 0.44,
        w * 0.55, h * 0.34,
      )
      ..cubicTo(
        w * 0.74, h * 0.22,
        w * 0.86, h * 0.18,
        w, h * 0.23,
      )
      ..lineTo(w, h * 0.47)
      ..cubicTo(
        w * 0.79, h * 0.36,
        w * 0.67, h * 0.43,
        w * 0.48, h * 0.54,
      )
      ..cubicTo(
        w * 0.24, h * 0.70,
        w * 0.12, h * 0.58,
        0, h * 0.44,
      )
      ..close();

    canvas.drawPath(
      middleWave,
      Paint()
        ..color = const Color(0xFFFFA2D4)
            .withValues(alpha: 0.39),
    );

    final bottomWave = Path()
      ..moveTo(0, h * 0.47)
      ..cubicTo(
        w * 0.20, h * 0.71,
        w * 0.40, h * 0.61,
        w * 0.60, h * 0.49,
      )
      ..cubicTo(
        w * 0.77, h * 0.39,
        w * 0.87, h * 0.43,
        w, h * 0.51,
      )
      ..lineTo(w, h * 0.76)
      ..cubicTo(
        w * 0.82, h * 0.59,
        w * 0.76, h * 0.39,
        w * 0.53, h * 0.48,
      )
      ..cubicTo(
        w * 0.32, h * 0.56,
        w * 0.19, h * 0.77,
        0, h * 0.59,
      )
      ..close();

    canvas.drawPath(
      bottomWave,
      Paint()
        ..color = const Color(0xFFF37ACF)
            .withValues(alpha: 0.40),
    );
  }

  @override
  bool shouldRepaint(covariant _PinkWavePainter old) {
    return false;
  }
}

class _TicketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    const radius = 13.0;
    const notchRadius = 11.0;
    final middle = h / 2;

    final path = Path()
      ..moveTo(radius, 0)

      ..lineTo(w - radius, 0)
      ..quadraticBezierTo(w, 0, w, radius)

      ..lineTo(w, middle - notchRadius)
      ..arcToPoint(
        Offset(w, middle + notchRadius),
        radius: const Radius.circular(notchRadius),
        clockwise: false,
      )

      ..lineTo(w, h - radius)
      ..quadraticBezierTo(w, h, w - radius, h)
      ..lineTo(radius, h)
      ..quadraticBezierTo(0, h, 0, h - radius)

      ..lineTo(0, middle + notchRadius)
      ..arcToPoint(
        Offset(0, middle - notchRadius),
        radius: const Radius.circular(notchRadius),
        clockwise: false,
      )

      ..lineTo(0, radius)
      ..quadraticBezierTo(0, 0, radius, 0)
      ..close();

    canvas.drawShadow(
      path,
      const Color(0x44000000),
      3,
      false,
    );

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF303030)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.25,
    );
  }

  @override
  bool shouldRepaint(covariant _TicketPainter old) {
    return false;
  }
}
