import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../viewmodels/ai_assistant_viewmodel.dart';

class AiAssistantPage extends StatefulWidget {
  const AiAssistantPage({super.key});

  @override
  State<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage> {
  static const Color purple = Color(0xFF8040BC);
  static const Color pink = Color(0xFFE344A2);
  static const Color lightPurple = Color(0xFFF5F2FF);

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final AiAssistantViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AiAssistantViewModel();
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (!mounted) return;
    setState(() {});
    _scrollToLatest();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? selectedQuestion]) {
    final question = (selectedQuestion ?? _messageController.text).trim();
    if (question.isEmpty || _viewModel.isSending) return;

    _messageController.clear();
    _viewModel.sendMessage(question);
    _scrollToLatest();
  }

  void _scrollToLatest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _topicCard(String title, String imagePath, Color iconColor) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: 2,
      child: InkWell(
        onTap: () => _sendMessage(title),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: Image.asset(
                    imagePath,
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF201077),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _messageBubble(String role, String text) {
    final isUser = role == 'user';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Image.asset(
                'assets/images/icon_aiteks.png',
                width: 34,
                height: 34,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFFE8D8FF) : lightPurple,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isUser
                  ? Text(
                      text,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    )
                  : MarkdownBody(
                      data: text,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                        strong: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        listBullet: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _faqSection() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E5E5))),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _viewModel.toggleFaq,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: purple, size: 22),
                  const SizedBox(width: 9),
                  const Expanded(
                    child: Text(
                      'Pertanyaan yang sering ditanyakan',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Icon(
                    _viewModel.faqExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    size: 26,
                  ),
                ],
              ),
            ),
          ),
          if (_viewModel.faqExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: _viewModel.faqs.map((question) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Material(
                      color: lightPurple,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () => _sendMessage(question),
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 9,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  question,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ),
                              const Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEAEAEA))),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Color(0xFFAA84F7), size: 13),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _messageController,
              textInputAction: TextInputAction.send,
              enabled: !_viewModel.isSending,
              onSubmitted: _viewModel.isSending ? null : (_) => _sendMessage(),
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Tanyakan sesuatu tentang layanan Posyandu...',
                hintStyle: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFB4A3D3),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E2E2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E2E2)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 7),
          InkWell(
            onTap: _viewModel.isSending ? null : () => _sendMessage(),
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: _viewModel.isSending
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: purple,
                        ),
                      )
                    : Image.asset(
                        'assets/images/icon_send.png',
                        width: 36,
                        height: 36,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                // HEADER LITA
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1EEFF),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 28,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'AI Assistant LITA',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF201077),
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/images/icon_ai.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(10),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD6BDEB),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 18,
                                color: Colors.black87,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Pertanyaanmu dikirim ke LITA untuk dijawab oleh AI.\n'
                                  'Jawaban mungkin membutuhkan beberapa detik.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F7FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  color: Color(0xFFAA84F7),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Apa yang ingin kamu ketahui?',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              childAspectRatio: 2.7,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              children: [
                                _topicCard('Jadwal Posyandu', 'assets/images/icon_jadwal.png', purple),
                                _topicCard('Antrean Saya', 'assets/images/icon_antrean.png', purple),
                                _topicCard('Perkembangan Peserta', 'assets/images/icon_grafik.png', pink),
                                _topicCard('Riwayat Pemeriksaan', 'assets/images/icon_riwayat.png', purple),
                                _topicCard('Tentang Balita', 'assets/images/icon_balita.png', pink),
                                _topicCard('Tentang Lansia', 'assets/images/icon_lansia.png', purple),
                                _topicCard('Tentang Ibu Hamil', 'assets/images/icon_ibuhamil.png', purple),
                                _topicCard('Hasil Pemeriksaan', 'assets/images/icon_hasilpemeriksaan.png', purple),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      ..._viewModel.messages.map((message) =>
                          _messageBubble(message.role, message.text)),
                      if (_viewModel.isSending)
                        _messageBubble('assistant', 'LITA sedang menyiapkan jawaban...'),
                    ],
                  ),
                ),
                _faqSection(),
                _chatInput(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
