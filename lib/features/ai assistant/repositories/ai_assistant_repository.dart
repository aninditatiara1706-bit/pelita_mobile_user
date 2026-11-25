import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AiAssistantRepository {
  static String get chatApiUrl =>
      kIsWeb || defaultTargetPlatform != TargetPlatform.android
          ? 'http://localhost:5000/api/chat'
          : 'http://10.0.2.2:5000/api/chat';

  Future<String> requestAnswer(String question) async {
    final response = await http
        .post(
          Uri.parse(chatApiUrl),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'question': question}),
        )
        .timeout(const Duration(seconds: 90));

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(responseData['error'] ?? 'Server AI mengembalikan error.');
    }

    final answer = responseData['answer'];
    if (answer is! String || answer.trim().isEmpty) {
      throw const FormatException('Server AI tidak mengirim jawaban.');
    }

    return answer.trim();
  }
}
