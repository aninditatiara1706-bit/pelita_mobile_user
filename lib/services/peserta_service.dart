
import 'dart:convert';
import 'auth_service.dart';

class PesertaService {
  static const String baseUrl = 'http://localhost:4000/api';

  // Mengambil peserta milik akun yang sedang login
  Future<List<Map<String, dynamic>>> getMyParticipants() async {
    try {
      final response = await AuthService.client
          .get(
            Uri.parse('$baseUrl/peserta/saya'),
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
          responseData['message'] ?? 'Gagal mengambil data peserta',
        );
      }

      final List<dynamic> data = responseData['data'] ?? [];

      return data
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil daftar peserta: $e');
    }
  }

  // Mengambil detail peserta beserta riwayat pemeriksaan
  Future<Map<String, dynamic>> getParticipantDetail(
    String pesertaId,
  ) async {
    try {
      final response = await AuthService.client
          .get(
            Uri.parse('$baseUrl/peserta/$pesertaId'),
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
          responseData['message'] ?? 'Gagal mengambil detail peserta',
        );
      }

      return Map<String, dynamic>.from(
        responseData['data'] as Map,
      );
    } catch (e) {
      throw Exception('Gagal mengambil detail peserta: $e');
    }
  }
}
