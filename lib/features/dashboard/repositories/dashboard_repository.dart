import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/dashboard_model.dart';

class DashboardRepository {
  // Android Emulator menggunakan 10.0.2.2
  static const String baseUrl = 'http://10.0.2.2:4000/api';

  final http.Client client;

  DashboardRepository({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> _get(String endpoint) async {
    final response = await client
        .get(
          Uri.parse('$baseUrl$endpoint'),
          headers: {'Accept': 'application/json'},
        )
        .timeout(const Duration(seconds: 15));

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Format response backend tidak valid');
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        decoded['success'] != true) {
      throw Exception(decoded['message'] ?? 'Gagal mengambil data');
    }

    return decoded;
  }

  Future<DashboardUser> getUser() async {
    final response = await _get('/auth/me');

    final data = response['data'];

    if (data is! Map) {
      throw Exception('Data pengguna tidak valid');
    }

    final user = data['user'] is Map
        ? Map<String, dynamic>.from(data['user'])
        : Map<String, dynamic>.from(data);

    return DashboardUser.fromJson(user);
  }

  Future<int> getUnreadCount() async {
    final response = await _get('/notifikasi/unread-count');

    final data = response['data'];

    if (data is Map) {
      return (data['count'] as num?)?.toInt() ?? 0;
    }

    return 0;
  }

  Future<List<GrowthRecord>> getGrowthRecords() async {
    final response = await _get('/pemeriksaan/my');

    final data = response['data'];

    if (data is! List) {
      throw Exception('Format data pemeriksaan tidak valid');
    }

    final hasil = <GrowthRecord>[];

    for (final item in data) {
      if (item is! Map) continue;

      final json = Map<String, dynamic>.from(item);

      final tanggal = DateTime.tryParse(
        json['tanggalPemeriksaan']?.toString() ?? '',
      );

      if (tanggal == null) continue;

      final record = GrowthRecord.fromJson(json);

      if (record.berat == null &&
          record.tinggi == null &&
          record.lingkarKepala == null) {
        continue;
      }

      hasil.add(record);
    }

    hasil.sort((a, b) => a.tanggal.compareTo(b.tanggal));

    return hasil;
  }

  void dispose() {
    client.close();
  }
}
