import 'dart:convert';
import 'package:http/browser_client.dart';

class AuthService {
  static const String baseUrl =
      'http://localhost:4000/api';

  // BrowserClient memungkinkan pengiriman HTTP-only cookie
  static final BrowserClient client = BrowserClient()
    ..withCredentials = true;

  // LOGIN
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'email': email.trim().toLowerCase(),
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final responseData =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 ||
          responseData['success'] != true) {
        throw Exception(
          responseData['message'] ?? 'Login gagal',
        );
      }

      final data = Map<String, dynamic>.from(
        responseData['data'] as Map,
      );

      return {
        'success': true,
        'message': responseData['message'],
        'user': data['user'],
      };
    } catch (e) {
      throw Exception('Login gagal: $e');
    }
  }

  // CEK SESSION / USER LOGIN
  Future<Map<String, dynamic>> getMe() async {
    try {
      final response = await client
          .get(
            Uri.parse('$baseUrl/auth/me'),
            headers: {
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      final responseData =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 ||
          responseData['success'] != true) {
        throw Exception(
          responseData['message'] ?? 'Session tidak valid',
        );
      }

      return Map<String, dynamic>.from(
        responseData['data'] as Map,
      );
    } catch (e) {
      throw Exception('Gagal memeriksa session: $e');
    }
  }

  // LOGOUT
  Future<void> logout() async {
    try {
      final response = await client
          .post(
            Uri.parse('$baseUrl/auth/logout'),
            headers: {
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('Logout gagal');
      }
    } catch (e) {
      throw Exception('Gagal logout: $e');
    }
  }
}
