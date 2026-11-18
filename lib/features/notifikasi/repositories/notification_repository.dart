
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification_model.dart';

class NotificationRepository {
  // ================================================
  // KONFIGURASI BACKEND
  // ================================================

  // Android Emulator:
  // 10.0.2.2 mengarah ke localhost komputer.

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:4000/api',
  );

  static const String _cookieKey =
      'pelita_session_cookie';

  final http.Client _client;

  NotificationRepository({
    http.Client? client,
  }) : _client = client ?? http.Client();

  // ================================================
  // COOKIE SESSION
  // ================================================

  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();

    final cookie = prefs.getString(_cookieKey);

    return {
      'Accept': 'application/json',
      if (cookie != null && cookie.isNotEmpty)
        'Cookie': cookie,
    };
  }

  Future<void> _simpanCookie(
    http.Response response,
  ) async {
    final setCookie = response.headers['set-cookie'];

    if (setCookie == null || setCookie.isEmpty) {
      return;
    }

    final cookie = setCookie.split(';').first;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_cookieKey, cookie);
  }

  // Gunakan fungsi ini jika proses login kamu
  // mendapatkan cookie session dari backend.

  Future<void> simpanCookieLogin(String cookie) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_cookieKey, cookie);
  }

  // ================================================
  // REQUEST BACKEND
  // ================================================

  Future<http.Response> _get(String endpoint) async {
    final headers = await _headers();

    final response = await _client.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );

    await _simpanCookie(response);

    return response;
  }

  // ================================================
  // MENGAMBIL NOTIFIKASI
  // ================================================

  Future<NotificationData> ambilNotifikasi() async {
    try {
      final responses = await Future.wait([
        _get('/antrean/saya'),
        _get('/jadwal'),
      ]);

      final antreanResponse = _decodeResponse(
        responses[0],
        'Gagal mengambil data antrean',
      );

      final jadwalResponse = _decodeResponse(
        responses[1],
        'Gagal mengambil jadwal',
      );

      final antreanData =
          antreanResponse['data'] as List? ?? [];

      final jadwalData =
          jadwalResponse['data'] as List? ?? [];

      // ============================================
      // FILTER JADWAL HARI INI
      // ============================================

      final today = DateTime.now();

      final todayString =
          '${today.year}-'
          '${today.month.toString().padLeft(2, '0')}-'
          '${today.day.toString().padLeft(2, '0')}';

      final filteredJadwal = jadwalData
          .whereType<Map>()
          .map(
            (item) => Map<String, dynamic>.from(item),
          )
          .where((item) {
            final tanggal =
                item['tanggal']?.toString() ?? '';

            return tanggal.startsWith(todayString);
          })
          .map(JadwalNotification.fromJson)
          .toList();

      // ============================================
      // KONVERSI DATA ANTREAN
      // ============================================

      final antrean = antreanData
          .whereType<Map>()
          .map(
            (item) => Map<String, dynamic>.from(item),
          )
          .map(AntreanNotification.fromJson)
          .toList();

      return NotificationData(
        antrean: antrean,
        jadwal: filteredJadwal,
      );
    } catch (e) {
      debugPrint('Notification Repository Error: $e');

      rethrow;
    }
  }

  // ================================================
  // DECODE RESPONSE
  // ================================================

  Map<String, dynamic> _decodeResponse(
    http.Response response,
    String defaultMessage,
  ) {
    dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception(
        'Response backend bukan JSON yang valid '
        '(HTTP ${response.statusCode})',
      );
    }

    if (response.statusCode != 200) {
      final message = decoded is Map
          ? decoded['message'] ?? defaultMessage
          : defaultMessage;

      throw Exception(message.toString());
    }

    if (decoded is! Map) {
      throw Exception('Format response backend tidak valid');
    }

    return Map<String, dynamic>.from(decoded);
  }

  // ================================================
  // CLOSE CLIENT
  // ================================================

  void dispose() {
    _client.close();
  }
}
