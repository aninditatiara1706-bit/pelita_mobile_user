import 'package:flutter/material.dart';

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

  bool faqExpanded = false;

  final List<Map<String, String>> messages = [
    {
      'role': 'assistant',
      'text':
          'Halo! 👋\n'
          'Aku AI Assistant LITA, siap untuk membantu '
          'kamu mendapatkan informasi seputar layanan '
          'Posyandu, data kesehatan keluarga, dan hal lainnya.\n\n'
          'Kamu bisa pilih salah satu topik di atas atau '
          'tanyakan langsung yang ingin kamu ketahui, ya!',
    },
  ];

  final List<String> faqs = [
    'Apa hasil pemeriksaan terakhir Budi?',
    'Bagaimana cara mengontrol diabetes?',
    'Pemeriksaan ibu hamil meliputi apa saja?',
    'Bagaimana cara menambah anak ke akun?',
    'Apa yang perlu dibawa saat ke Posyandu?',
  ];

  final Map<String, String> responses = {
    'Jadwal Posyandu':
        'Kamu dapat melihat jadwal kegiatan melalui '
        'menu Jadwal Posyandu. Pastikan datang sesuai '
        'tanggal dan jam yang telah ditentukan.',
    'Antrean Saya':
        'Informasi nomor antrean dan status pelayanan '
        'dapat kamu lihat melalui menu Antrean Saya.',
    'Perkembangan Peserta':
        'Perkembangan kesehatan peserta dapat '
        'dipantau melalui data pemeriksaan dan '
        'catatan pertumbuhan yang tersedia.',
    'Riwayat Pemeriksaan':
        'Riwayat pemeriksaan berisi catatan pelayanan '
        'kesehatan yang pernah diikuti peserta.',
    'Tentang Balita':
        'Pemantauan tumbuh kembang balita meliputi '
        'berat badan, tinggi badan, dan perkembangan '
        'sesuai usia.',
    'Tentang Lansia':
        'Pelayanan Posyandu lansia dapat mencakup '
        'pemantauan tekanan darah, berat badan, '
        'serta edukasi kesehatan.',
    'Tentang Ibu Hamil':
        'Ibu hamil dianjurkan menjalani pemeriksaan '
        'kehamilan secara rutin sesuai arahan '
        'tenaga kesehatan.',
    'Hasil Pemeriksaan':
        'Hasil pemeriksaan dapat dilihat melalui '
        'menu riwayat atau hasil pemeriksaan '
        'jika data sudah tersedia.',
    'Apa hasil pemeriksaan terakhir Budi?':
        'Untuk melihat hasil pemeriksaan terakhir '
        'Budi, buka menu Hasil Pemeriksaan. '
        'Data pasien belum terhubung pada versi ini.',
    'Bagaimana cara mengontrol diabetes?':
        'Pengendalian diabetes umumnya meliputi '
        'pola makan sehat, aktivitas fisik, '
        'pemantauan gula darah, dan penggunaan '
        'obat sesuai petunjuk tenaga kesehatan.',
    'Pemeriksaan ibu hamil meliputi apa saja?':
        'Pemeriksaan kehamilan dapat meliputi '
        'pengukuran tekanan darah, berat badan, '
        'pemeriksaan kondisi janin, dan pemeriksaan '
        'lain sesuai kebutuhan.',
    'Bagaimana cara menambah anak ke akun?':
        'Buka menu anggota keluarga, lalu pilih '
        'tambah anggota dan isi data anak '
        'sesuai formulir yang tersedia.',
    'Apa yang perlu dibawa saat ke Posyandu?':
        'Siapkan dokumen identitas yang diperlukan, '
        'buku KIA atau catatan kesehatan jika ada, '
        'dan perlengkapan pribadi sesuai kebutuhan.',
  };

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? selectedQuestion]) {
    final question = (selectedQuestion ?? _messageController.text).trim();

    if (question.isEmpty) return;

    final pesan = question.toLowerCase().trim();

    String answer;

    if ([
      'hai',
      'hi',
      'halo',
      'hello',
      'hey',
      'pagi',
      'siang',
      'malam',
    ].contains(pesan)) {
      answer =
          'Halo juga! 👋💜\n'
          'Aku LITA, asisten virtual PELITA.\n\n'
          'Ada yang bisa aku bantu hari ini? '
          'Kamu bisa bertanya tentang jadwal Posyandu, '
          'antrean, pemeriksaan kesehatan, atau layanan lainnya.';
    } else if (pesan.contains('terima kasih') ||
        pesan.contains('makasih') ||
        pesan.contains('thanks')) {
      answer =
          'Sama-sama! 💜 Senang bisa membantu kamu. '
          'Kalau ada pertanyaan lain, jangan ragu bertanya, ya!';
    } else if (pesan == 'oke' || pesan == 'ok' || pesan == 'baik') {
      answer = 'Siap! 😊 Ada lagi yang ingin kamu tanyakan?';
    } else {
      answer =
          responses[question] ??
          'Maaf, aku belum menemukan jawaban untuk '
              'pertanyaan tersebut. 💜\n\n'
              'Coba pilih salah satu topik di atas atau '
              'tanyakan hal lain seputar layanan Posyandu, ya!';
    }

    setState(() {
      messages.add({'role': 'user', 'text': question});
      messages.add({'role': 'assistant', 'text': answer});
      faqExpanded = false;
    });

    _messageController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
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

  Widget _messageBubble(Map<String, String> message) {
    final isUser = message['role'] == 'user';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
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
              child: Text(
                message['text'] ?? '',
                style: const TextStyle(fontSize: 14, height: 1.4),
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
            onTap: () {
              setState(() {
                faqExpanded = !faqExpanded;
              });
            },
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
                    faqExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    size: 26,
                  ),
                ],
              ),
            ),
          ),
          if (faqExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: faqs.map((question) {
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
              onSubmitted: (_) => _sendMessage(),
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
  onTap: () => _sendMessage(),
  borderRadius: BorderRadius.circular(24),
  child: SizedBox(
    width: 48,
    height: 48,
    child: Center(
      child: Image.asset(
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

                // TOPIK DAN PERCAKAPAN
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
    'Sesi dimulai pukul 12.20 dan tersimpan aman.\n'
    'Percakapanmu akan terhapus otomatis dalam 24 jam.',
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
                                _topicCard(
                                  'Jadwal Posyandu',
                                  'assets/images/icon_jadwal.png',
                                  purple,
                                ),
                                _topicCard(
                                  'Antrean Saya',
                                  'assets/images/icon_antrean.png',
                                  purple,
                                ),
                                _topicCard(
                                  'Perkembangan Peserta',
                                  'assets/images/icon_grafik.png',
                                  pink,
                                ),
                                _topicCard(
                                  'Riwayat Pemeriksaan',
                                  'assets/images/icon_riwayat.png',
                                  purple,
                                ),
                                _topicCard(
                                  'Tentang Balita',
                                  'assets/images/icon_balita.png',
                                  pink,
                                ),
                                _topicCard(
                                  'Tentang Lansia',
                                  'assets/images/icon_lansia.png',
                                  purple,
                                ),
                                _topicCard(
                                  'Tentang Ibu Hamil',
                                  'assets/images/icon_ibuhamil.png',
                                  purple,
                                ),
                                _topicCard(
                                  'Hasil Pemeriksaan',
                                  'assets/images/icon_hasilpemeriksaan.png',
                                  purple,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      ...messages.map(_messageBubble),
                    ],
                  ),
                ),

                // FAQ DAPAT DIBUKA DAN DITUTUP
                _faqSection(),

                // KOLOM KIRIM PESAN
                _chatInput(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
