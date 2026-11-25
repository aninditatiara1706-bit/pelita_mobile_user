import 'dart:convert';

import '../../../services/auth_service.dart';
import '../models/riwayat_pelayanan_model.dart';

class RiwayatPelayananRepository {
  Future<List<RiwayatPelayananModel>> getRiwayatPelayanan() async {
    final response = await AuthService.client
        .get(
          Uri.parse(
            '${AuthService.baseUrl}/pemeriksaan/saya',
          ),
          headers: const {
            'Accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 15));

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Format response backend tidak valid');
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
       decoded['success'] != true) {
      throw Exception(
        decoded['message'] ??
            'Gagal mengambil riwayat pemeriksaan',
      );
    }

    final data = decoded['data'];

    if (data is! List) {
      throw Exception('Data riwayat tidak valid');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(
          (item) => RiwayatPelayananModel.fromJson(item),
        )
        .toList();
  }
}