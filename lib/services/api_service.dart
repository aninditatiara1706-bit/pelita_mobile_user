import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:4000';
  static Future<void> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/jadwal')
      );

      print('Status koneksi: ${response.statusCode}');
      print('Respons backend: ${response.body}');
    } catch (e) {
      print('Koneksi gagal: $e');
    }
  }
}