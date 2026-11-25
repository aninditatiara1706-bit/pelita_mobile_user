import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../services/auth_service.dart';
import '../model/profile_model.dart';
import '../../profil peserta/models/peserta_model.dart';

class ProfileRepository {
  Future<ProfileData> getProfile() async {
    final result = await AuthService().getMe();

    final user = result['user'] is Map
        ? Map<String, dynamic>.from(result['user'])
        : result;

    return ProfileData(
      nama: (user['nama'] ??
              user['name'] ??
              user['namaLengkap'] ??
              '')
          .toString(),
      telepon: (user['telepon'] ??
              user['noTelepon'] ??
              user['phone'] ??
              '')
          .toString(),
      email: (user['email'] ?? '').toString(),
      avatar: (user['avatar'] ??
              'assets/images/avatar_siti.png')
          .toString(),
    );
  }

  Future<List<Peserta>> getParticipants() async {
    final url = '${AuthService.baseUrl}/peserta/saya';

    // DEBUG: cek URL yang benar-benar digunakan
    debugPrint('PROFILE API URL: $url');

    final response = await AuthService.client
        .get(
          Uri.parse(url),
          headers: {
            'Accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 15));

    debugPrint('PROFILE API STATUS: ${response.statusCode}');
    debugPrint('PROFILE API RESPONSE: ${response.body}');

    final responseData =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200 ||
        responseData['success'] != true) {
      throw Exception(
        responseData['message'] ??
            'Gagal mengambil data peserta',
      );
    }

    final List<dynamic> data =
        responseData['data'] as List<dynamic>? ?? [];

    return data
        .map(
          (item) => ProfilePesertaMapper.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}