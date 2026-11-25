import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/auth_service.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Validasi session langsung ke backend
      await AuthService().getMe();

      _isLoggedIn = true;

      // Sinkronkan status lokal
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
    } catch (e) {
      _isLoggedIn = false;

      // Session tidak valid, hapus status lokal
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);

      debugPrint('Session tidak valid: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}