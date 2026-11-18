import 'dart:convert';

import '../../../services/auth_service.dart';
import '../models/pendaftaran_model.dart';

class PendaftaranRepositories {
  Future<String> simpanPendaftaran(PendaftaranModel data) async {
    final response = await AuthService.client
        .post(
          Uri.parse('${AuthService.baseUrl}/peserta'),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data.toJson()),
        )
        .timeout(const Duration(seconds: 15));

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Format response backend tidak valid');
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        decoded['success'] != true) {
      throw Exception(decoded['message'] ?? 'Pendaftaran peserta gagal');
    }

    return decoded['message']?.toString() ?? 'Pendaftaran peserta berhasil';
  }
}
