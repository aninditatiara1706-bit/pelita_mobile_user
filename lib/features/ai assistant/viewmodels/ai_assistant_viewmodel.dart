import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/ai_message_model.dart';
import '../repositories/ai_assistant_repository.dart';

class AiAssistantViewModel extends ChangeNotifier {
  final AiAssistantRepository _repository;

  AiAssistantViewModel({AiAssistantRepository? repository})
      : _repository = repository ?? AiAssistantRepository();

  bool _isSending = false;
  bool _faqExpanded = false;
  final List<AiMessageModel> _messages = [
    const AiMessageModel(
      role: 'assistant',
      text: 'Halo! 👋\n'
          'Aku AI Assistant LITA, siap untuk membantu kamu mendapatkan informasi '
          'seputar layanan Posyandu, data kesehatan keluarga, dan hal lainnya.\n\n'
          'Kamu bisa pilih salah satu topik di atas atau tanyakan langsung '
          'yang ingin kamu ketahui, ya!',
    ),
  ];

  final List<String> faqs = const [
    'Apa hasil pemeriksaan terakhir Budi?',
    'Bagaimana cara mengontrol diabetes?',
    'Pemeriksaan ibu hamil meliputi apa saja?',
    'Bagaimana cara menambah anak ke akun?',
    'Apa yang perlu dibawa saat ke Posyandu?',
  ];

  bool get isSending => _isSending;
  bool get faqExpanded => _faqExpanded;
  List<AiMessageModel> get messages => List.unmodifiable(_messages);

  void toggleFaq() {
    _faqExpanded = !_faqExpanded;
    notifyListeners();
  }

  Future<void> sendMessage(String question) async {
    final trimmedQuestion = question.trim();
    if (trimmedQuestion.isEmpty || _isSending) return;

    _isSending = true;
    _faqExpanded = false;
    _messages.add(AiMessageModel(role: 'user', text: trimmedQuestion));
    notifyListeners();

    String answer;
    try {
      answer = await _repository.requestAnswer(trimmedQuestion);
    } on TimeoutException {
      answer = 'Server AI terlalu lama merespons. Coba lagi sebentar.';
    } on http.ClientException catch (error) {
      debugPrint('LITA connection failed: $error');
      answer = 'Tidak dapat terhubung ke server AI. Pastikan backend chatbot '
          'berjalan di port 5000.';
    } catch (error) {
      debugPrint('LITA request failed: $error');
      answer = error.toString().replaceFirst('Exception: ', '');
    }

    _messages.add(AiMessageModel(role: 'assistant', text: answer));
    _isSending = false;
    notifyListeners();
  }
}
