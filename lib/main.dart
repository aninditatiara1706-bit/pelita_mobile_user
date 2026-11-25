import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/splash/views/splash_page.dart';
import 'features/auth/views/login_page.dart';
import 'features/dashboard/view/dashboard_page.dart';
import 'features/profile/view/profile_page.dart';
import 'services/api_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());

  ApiService.testConnection();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PELITA',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE0468F),
        ),
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
        scaffoldBackgroundColor: Colors.white,
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}