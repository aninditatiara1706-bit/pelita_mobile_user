import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'jadwal_posyandu_page.dart';

class DaftarPosyanduPage extends StatefulWidget {
  const DaftarPosyanduPage({super.key});

  @override
  State<DaftarPosyanduPage> createState() =>
      _DaftarPosyanduPageState();
}

class _DaftarPosyanduPageState
    extends State<DaftarPosyanduPage> {
  int _selectedPeserta = 0;

  final List<Map<String, String>> _peserta = [
    {
      'nama': 'Raka',
      'keterangan': 'Balita 3 tahun',
      'gambar': 'assets/images/avatar_raka.png',
    },
    {
  'nama': 'Sari',
  'keterangan': 'Lansia 65 Tahun',
  'gambar': 'assets/images/avatar_sari.png',
},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 28),

              Center(
                child: Text(
                  'Daftar Posyandu',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Pilih Peserta',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 14),

              ...List.generate(_peserta.length, (index) {
                return _buildPesertaCard(index);
              }),

              const Spacer(),

              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF9148D8),
                      Color(0xFFE0468F),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF282028),
                    width: 0.8,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    
onTap: () {
  final nama = _peserta[_selectedPeserta]['nama']!;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => JadwalPosyanduPage(
        namaPeserta: nama,
      ),
    ),
  );
},

                    child: Center(
                      child: Text(
                        'Lanjutkan',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPesertaCard(int index) {
    final peserta = _peserta[index];
    final selected = _selectedPeserta == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeserta = index;
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: const Color(0xFF666666),
            width: 0.9,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFFF4EAF6),
              backgroundImage: AssetImage(
                peserta['gambar']!,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    peserta['nama']!,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    peserta['keterangan']!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xFFD43BDE)
                      : const Color(0xFF555555),
                  width: 1.4,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD43BDE),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
