import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        isLoggedIn ? '/dashboard' : '/login',
      );
    } catch (e) {
      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/login');
    }
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