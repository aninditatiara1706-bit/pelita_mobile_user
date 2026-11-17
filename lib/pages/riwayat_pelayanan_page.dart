import 'package:flutter/material.dart';
import 'detail_riwayat_pelayanan_page.dart';

class RiwayatPelayananPage extends StatefulWidget {
  const RiwayatPelayananPage({super.key});

  @override
  State<RiwayatPelayananPage> createState() =>
      _RiwayatPelayananPageState();
}

class _RiwayatPelayananPageState
    extends State<RiwayatPelayananPage> {

  String _searchQuery = '';

  final List<Map<String, String>> _riwayat = [
    {
      'name': 'Raka',
      'category': 'Balita',
      'date': '20 September 2026',
      'location': 'Posyandu Melati',
      'avatar': 'assets/images/avatar_raka.png',
    },
    {
      'name': 'Sari',
      'category': 'Lansia',
      'date': '1 Oktober 2026',
      'location': 'Posyandu Melati',
      'avatar': 'assets/images/avatar_sari.png',
    },
    {
      'name': 'Sari',
      'category': 'Lansia',
      'date': '12 Oktober 2026',
      'location': 'Posyandu Melati',
      'avatar': 'assets/images/avatar_sari.png',
    },
    {
      'name': 'Raka',
      'category': 'Balita',
      'date': '20 Oktober 2026',
      'location': 'Posyandu Melati',
      'avatar': 'assets/images/avatar_raka.png',
    },
  ];

  @override
  Widget build(BuildContext context) {

    final hasilPencarian = _riwayat.where((item) {
      final nama = item['name']!.toLowerCase();

      return nama.contains(_searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              GestureDetector(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/dashboard',
                    (route) => false,
                  );
                },
                child: const Icon(
                  Icons.arrow_back,
                  size: 28,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  'Riwayat Pelayanan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery =
                          value.toLowerCase().trim();
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Cari nama peserta....',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: hasilPencarian.isEmpty

                    ? const Center(
                        child: Text(
                          'Riwayat tidak ditemukan',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      )

                    : ListView.builder(
                        itemCount: hasilPencarian.length,
                        itemBuilder: (context, index) {

                          final item =
                              hasilPencarian[index];

                          return _buildHistoryCard(
                            context: context,
                            name: item['name']!,
                            category: item['category']!,
                            date: item['date']!,
                            location: item['location']!,
                            avatar: item['avatar']!,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required BuildContext context,
    required String name,
    required String category,
    required String date,
    required String location,
    required String avatar,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const DetailRiwayatPelayananPage(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.black54,
          ),
        ),
        child: Row(
          children: [

            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.brown.shade200,
              backgroundImage: AssetImage(avatar),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              size: 28,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
