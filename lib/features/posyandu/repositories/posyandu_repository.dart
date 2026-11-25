import 'dart:convert';

import '../../../services/auth_service.dart';
import '../models/posyandu_model.dart';

class PosyanduRepository {
  Future<List<PesertaPosyandu>> ambilPeserta() async {
    final response = await AuthService.client
        .get(
          Uri.parse('${AuthService.baseUrl}/peserta/saya'),
          headers: const {
            'Accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 15));

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Format response backend tidak valid');
    }

    if (response.statusCode != 200 ||
    decoded['success'] != true) {
      throw Exception(
        decoded['message'] ?? 'Gagal mengambil peserta',
      );
    }

    final List<dynamic> data =
        decoded['data'] as List<dynamic>? ?? [];

    return data.map((item) {
      return PesertaPosyandu.fromJson(
        Map<String, dynamic>.from(item),
      );
    }).toList();
  }
}