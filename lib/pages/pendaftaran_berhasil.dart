import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PendaftaranBerhasilPage extends StatefulWidget {
  const PendaftaranBerhasilPage({super.key});

  @override
  State<PendaftaranBerhasilPage> createState() => _PendaftaranBerhasilPageState();
}

class _PendaftaranBerhasilPageState extends State<PendaftaranBerhasilPage>
    with SingleTickerProviderStateMixin {
  static const Color _purple = Color(0xFF9449B8);
  static const Color _pink = Color(0xFFE5507E);
  
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Mengatur durasi animasi saat menggambar (1.5 detik)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animationController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {

        await Future.delayed(const Duration(milliseconds: 1000));
        
        if (mounted) {
          _animationController.reset(); 
          _animationController.forward(); 
        }
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _kembaliKeHome(BuildContext context) {
    Navigator.of(context).popUntil((route) {
      return route.isFirst ||
          route.settings.name == '/dashboard' ||
          route.settings.name == '/beranda';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100, // Ukuran ikon 
                  height: 100,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _SuccessCheckPainter(_animationController.value),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Pendaftaran Berhasil!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 22, 
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Data Peserta\nBerhasil Ditambahkan', 
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14, 
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700], 
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50, 
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_purple, _pink],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12), 
                    ),
                    child: ElevatedButton(
                      onPressed: () => _kembaliKeHome(context),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Kembali ke Home',
                        style: GoogleFonts.poppins(
                          fontSize: 16, 
                          fontWeight: FontWeight.w600,
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
  }
}

class _SuccessCheckPainter extends CustomPainter {
  final double progress;

  _SuccessCheckPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = const Color(0xFFAC45C8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0 // Ketebalan garis
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.45;

    final circlePath = Path()
      ..addArc(
        Rect.fromCircle(center: center, radius: radius),
        -2.22,
        5.75,
      );

    final checkPath = Path()
      ..moveTo(size.width * 0.30, size.height * 0.50)
      ..lineTo(size.width * 0.45, size.height * 0.65)
      ..lineTo(size.width * 0.85, size.height * 0.25);

    _drawAnimatedPath(canvas, circlePath, stroke, progress);
    _drawAnimatedPath(canvas, checkPath, stroke, progress);
  }

  void _drawAnimatedPath(Canvas canvas, Path path, Paint paint, double progress) {
    final PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      final extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * progress,
      );
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SuccessCheckPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}