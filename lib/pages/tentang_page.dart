import 'package:flutter/material.dart';

import 'dashboard_page.dart';
import 'profile_page.dart';

class TentangPage extends StatelessWidget {
  const TentangPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Center(
                child: Text(
                  'Tentang Posyandu',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black54),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Posyandu Pelita merupakan pusat pelayanan kesehatan terpadu berbasis masyarakat yang berdedikasi untuk memberikan layanan kesehatan berkualitas, inklusif, dan terjangkau bagi seluruh lapisan masyarakat lokal. Dengan mengusung slogan "Peduli Ibu, Anak, dan Lansia", Posyandu Pelita hadir sebagai garda terdepan dalam merawat kesehatan keluarga secara menyeluruh pada setiap tahapan siklus kehidupan, mulai dari perawatan masa kehamilan ibu, pemantauan tumbuh kembang anak, hingga pendampingan kesehatan bagi para lanjut usia.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Pelayanan di Posyandu Pelita mencakup program Kesehatan Ibu dan Anak (KIA) yang berfokus pada deteksi dini serta pencegahan masalah gizi seperti stunting. Kegiatan rutinnya meliputi penimbangan berat badan, pengukuran tinggi badan dan lingkar kepala balita, pemberian suplemen vitamin A, obat cacing, serta pelayanan imunisasi dasar lengkap. Selain itu, para ibu hamil dan menyusui mendapatkan konseling gizi serta pemeriksaan kesehatan berkala untuk memastikan kesejahteraan ibu dan janin.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Tidak hanya berfokus pada balita dan Ibu, Posyandu Pelita juga memberikan perhatian penuh kepada para lansia melalui program Posyandu Lansia. Layanan ini meliputi pemeriksaan fisik rutin seperti pengecekan tekanan darah, gula darah, dan kolesterol, serta pendampingan pola hidup sehat dan kegiatan senam lansia untuk menjaga kebugaran fisik maupun mental. Didukung oleh kader kesehatan yang terlatih, Posyandu Pelita menyelenggarakan seluruh rangkaian kegiatan ini secara berkala setiap minggu kedua di balai warga setempat guna menciptakan masyarakat yang sehat, mandiri, dan sejahtera.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE05297),
              Color(0xFF7E3FB4), 
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: 1, // 1 = Tentang
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          onTap: (index) {

            if (index == 0) {
              // Jika menekan Home (index 0)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DashboardPage()), 
              );
            } else if (index == 2) {

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()), 
              );
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article), 
              label: 'Tentang',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}