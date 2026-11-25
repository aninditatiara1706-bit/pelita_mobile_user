import 'package:flutter/material.dart';

import '../models/riwayat_pelayanan_model.dart';
import '../viewmodels/riwayat_pelayanan_viewmodel.dart';

class RiwayatPelayananPage extends StatefulWidget {
  const RiwayatPelayananPage({super.key});

  @override
  State<RiwayatPelayananPage> createState() =>
      _RiwayatPelayananPageState();
}

class _RiwayatPelayananPageState extends State<RiwayatPelayananPage> {
  late final RiwayatPelayananViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = RiwayatPelayananViewModel();
    _viewModel.loadRiwayatPelayanan();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, child) {
        final riwayat = _viewModel.hasilPencarian;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      onChanged: _viewModel.searchRiwayat,
                      decoration: const InputDecoration(
                        hintText: 'Cari nama peserta....',
                        hintStyle: TextStyle(color: Colors.grey),
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
                    child: _viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _viewModel.errorMessage != null
                        ? Center(
                            child: Text(
                              _viewModel.errorMessage!,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : riwayat.isEmpty
                        ? Center(
                            child: Text(
                              _viewModel.searchQuery.isEmpty
                                  ? 'Riwayat belum tersedia'
                                  : 'Riwayat tidak ditemukan',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: riwayat.length,
                            itemBuilder: (context, index) {
                              final item = riwayat[index];

                              return _buildHistoryCard(item);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryCard(RiwayatPelayananModel item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailRiwayatPelayananPage(riwayat: item),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black54),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.brown.shade200,
              backgroundImage: AssetImage(item.avatar),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    item.category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    item.date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    item.location,
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

class DetailRiwayatPelayananPage extends StatelessWidget {
  final RiwayatPelayananModel riwayat;

  const DetailRiwayatPelayananPage({
    super.key,
    required this.riwayat,
  });

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
                child: const Icon(
                  Icons.arrow_back,
                  size: 28,
                  color: Colors.black,
                ),
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

              // IDENTITAS PESERTA
              Container(
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
                      radius: 35,
                      backgroundColor: Colors.brown.shade200,
                      backgroundImage: AssetImage(
                        riwayat.avatar,
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            riwayat.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            riwayat.category,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),

                          Text(
                            riwayat.date,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),

                          Text(
                            riwayat.location,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // HASIL PEMERIKSAAN
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.black54,
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hasil Pemeriksaan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildRowItem(
                      'Berat Badan',
                      riwayat.beratBadan,
                    ),

                    _buildRowItem(
                      'Tinggi Badan',
                      riwayat.tinggiBadan,
                    ),

                    _buildRowItem(
                      'Lingkar Kepala',
                      riwayat.lingkarKepala,
                    ),

                    const SizedBox(height: 16),

                    const Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      height: 1,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Catatan Pemeriksaan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      riwayat.catatan == '-' ||
                              riwayat.catatan.isEmpty
                          ? 'Tidak ada catatan pemeriksaan.'
                          : riwayat.catatan,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
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

  Widget _buildRowItem(
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}