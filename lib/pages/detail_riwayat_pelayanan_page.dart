import 'package:flutter/material.dart';

class DetailRiwayatPelayananPage extends StatelessWidget {
  const DetailRiwayatPelayananPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, size: 28, color: Colors.black),
              ),
              const SizedBox(height: 20),

              const Center(
                child: Text(
                  'Detail Riwayat Pelayanan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black54),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.brown.shade200,
                      backgroundImage: const AssetImage(
                        'assets/images/avatar_raka.png',
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Raka', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 4),
                        Text('Balita 3 Tahun', style: TextStyle(fontSize: 12)),
                        Text('20 September 2026', style: TextStyle(fontSize: 12)),
                        Text('Posyandu Melati', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black54),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      'Detail Pendaftaran',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    _buildRowItem('Nomor Antrean', 'A-12'),
                    _buildRowItem('Kategori Layanan', 'Pemeriksaan Anak'),
                    _buildRowItem('Waktu Daftar', '18.15 WIB'),

                    const SizedBox(height: 16),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      height: 1,
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Detail Pemeriksaan',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    _buildRowItem('Berat Badan', '11,2 kg'),
                    _buildRowItem('Tinggi Badan', '85 cm'),
                    _buildRowItem('Lingkar Kepala', '48 cm'),
                    _buildRowItem('Kondisi', 'Sehat'),

                    const SizedBox(height: 16),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      height: 1,
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Diagnosa/Catatan',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pertumbuhan sesuai usia. Tidak ada\nkeluhan',
                      style: TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}