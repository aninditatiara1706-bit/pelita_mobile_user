import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../dashboard/view/dashboard_page.dart';
import '../../auth/views/login_page.dart';
import '../viewmodels/splash_viewmodel.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 10));

    if (!mounted) return;

    bool isLoggedIn = false;

    try {
      final prefs = await SharedPreferences.getInstance();
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    } catch (e) {
      isLoggedIn = false;
    }

    if (!mounted) return;

    final Widget halamanTujuan = isLoggedIn
        ? const DashboardPage()
        : const LoginPage();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) {
          return halamanTujuan;
        },
        transitionDuration: const Duration(
          milliseconds: 750,
        ),
        reverseTransitionDuration: const Duration(
          milliseconds: 400,
        ),
        transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          );

          return FadeTransition(
            opacity: curvedAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenSize.height * 0.25,
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _TopWavePainter(
                    phase: _waveController.value * 2 * math.pi,
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: screenSize.height * 0.25,
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _BottomWavePainter(
                    phase: _waveController.value * 2 * math.pi,
                  ),
                );
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_pelita.png',
                  width: 170,
                  height: 170,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.local_hospital,
                      size: 100,
                      color: Colors.teal,
                    );
                  },
                ),
                const SizedBox(height: 18),
                const Text(
                  'PELITA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Aplikasi Posyandu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Kelurahan Sehat, Keluarga Hebat',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopWavePainter extends CustomPainter {
  final double phase;

  const _TopWavePainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    _drawLayer(
      canvas: canvas,
      size: size,
      baseHeightRatio: 0.78,
      amplitude: 16,
      frequency: 1.0,
      phaseShift: phase,
      tiltDrop: 24,
      colors: [
        const Color(0xFFF3A4C8).withValues(alpha: 0.45),
        const Color(0xFFE58BC6).withValues(alpha: 0.45),
      ],
    );

    _drawLayer(
      canvas: canvas,
      size: size,
      baseHeightRatio: 0.58,
      amplitude: 14,
      frequency: 1.15,
      phaseShift: phase + 1.3,
      tiltDrop: 16,
      colors: [
        const Color(0xFFEC7CB4).withValues(alpha: 0.65),
        const Color(0xFFD664C8).withValues(alpha: 0.65),
      ],
    );

    _drawLayer(
      canvas: canvas,
      size: size,
      baseHeightRatio: 0.38,
      amplitude: 12,
      frequency: 1.3,
      phaseShift: phase + 2.6,
      tiltDrop: 10,
      colors: [
        const Color(0xFFE05CA0),
        const Color(0xFFC246B8),
      ],
    );
  }

  void _drawLayer({
    required Canvas canvas,
    required Size size,
    required double baseHeightRatio,
    required double amplitude,
    required double frequency,
    required double phaseShift,
    required double tiltDrop,
    required List<Color> colors,
  }) {
    final path = Path()..moveTo(0, 0);
    const int steps = 60;
    final double baseY = size.height * baseHeightRatio;

    for (int i = 0; i <= steps; i++) {
      final double t = i / steps;
      final double x = t * size.width;
      final double wave = math.sin(t * frequency * math.pi * 2 + phaseShift) * amplitude;
      final double y = (baseY + t * tiltDrop + wave).clamp(0.0, size.height);
      path.lineTo(x, y);
    }

    path
      ..lineTo(size.width, 0)
      ..close();

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.topRight,
        colors: colors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TopWavePainter oldDelegate) {
    return oldDelegate.phase != phase;
  }
}

class _BottomWavePainter extends CustomPainter {
  final double phase;

  const _BottomWavePainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    _drawLayer(
      canvas: canvas,
      size: size,
      baseTopRatio: 0.22,
      amplitude: 16,
      frequency: 1.0,
      phaseShift: phase + 0.7,
      tiltRise: 22,
      colors: [
        const Color(0xFFF39CE0).withValues(alpha: 0.45),
        const Color(0xFFE378DC).withValues(alpha: 0.45),
      ],
    );

    _drawLayer(
      canvas: canvas,
      size: size,
      baseTopRatio: 0.42,
      amplitude: 14,
      frequency: 1.15,
      phaseShift: phase + 2.0,
      tiltRise: 14,
      colors: [
        const Color(0xFFE866D4).withValues(alpha: 0.65),
        const Color(0xFFCE4AD0).withValues(alpha: 0.65),
      ],
    );

    _drawLayer(
      canvas: canvas,
      size: size,
      baseTopRatio: 0.62,
      amplitude: 12,
      frequency: 1.3,
      phaseShift: phase + 3.4,
      tiltRise: 8,
      colors: [
        const Color(0xFFDC4AC4),
        const Color(0xFFAE2AB8),
      ],
    );
  }

  void _drawLayer({
    required Canvas canvas,
    required Size size,
    required double baseTopRatio,
    required double amplitude,
    required double frequency,
    required double phaseShift,
    required double tiltRise,
    required List<Color> colors,
  }) {
    final path = Path()..moveTo(0, size.height);
    const int steps = 60;
    final double baseY = size.height * baseTopRatio;

    for (int i = 0; i <= steps; i++) {
      final double t = i / steps;
      final double x = t * size.width;
      final double wave = math.sin(t * frequency * math.pi * 2 + phaseShift) * amplitude;
      final double y = (baseY - t * tiltRise + wave).clamp(0.0, size.height);
      path.lineTo(x, y);
    }

    path
      ..lineTo(size.width, size.height)
      ..close();

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BottomWavePainter oldDelegate) {
    return oldDelegate.phase != phase;
  }
}