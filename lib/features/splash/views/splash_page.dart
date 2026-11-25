import 'package:flutter/material.dart';

import '../../dashboard/view/dashboard_page.dart';
import '../../auth/views/login_page.dart';
import '../viewmodels/splash_viewmodel.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SplashViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = SplashViewModel();

    _initializeSplash();
  }

  Future<void> _initializeSplash() async {
    await _viewModel.checkLoginStatus();

    if (!mounted) return;

    final Widget halamanTujuan = _viewModel.isLoggedIn
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
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
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
    );
  }
}