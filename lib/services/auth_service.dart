import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'auth_http_client.dart';

class AuthService {
  static String get baseUrl {
    const configuredUrl = String.fromEnvironment('API_BASE_URL');
    if (configuredUrl.isNotEmpty) {
      return configuredUrl;
    }
    final host = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? '10.0.2.2'
        : 'localhost';
    return 'http://$host:4000/api';
  }

  static final client = createAuthHttpClient();

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
      final message = e.toString().replaceFirst('Exception: ', '');
      throw Exception('Login gagal: $message');
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
