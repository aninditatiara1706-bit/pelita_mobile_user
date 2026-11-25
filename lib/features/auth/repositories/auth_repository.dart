import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  // LOGIN
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final result = await _authService.login(
      email: email,
      password: password,
    );

    // Simpan status login hanya jika login berhasil
    if (result['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
    }

    return Map<String, dynamic>.from(result);
  }

  // REGISTER
  Future<Map<String, dynamic>> register({
    required String name,
    required String telepon,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(
      '${AuthService.baseUrl}/auth/register',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'telepon': telepon,
        'email': email,
        'password': password,
      }),
    );

    final Map<String, dynamic> responseData =
        response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : {};

    return {
      'statusCode': response.statusCode,
      'data': responseData,
    };
  }

  // LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      // Logout dari backend
      await _authService.logout();
    } finally {
      // Tetap hapus status login lokal
      await prefs.setBool('isLoggedIn', false);
    }
  }
}