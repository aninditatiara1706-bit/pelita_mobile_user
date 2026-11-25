class RiwayatPelayananModel {
  final String id;
  final String pesertaId;

  final String name;
  final String category;
  final String date;
  final String location;
  final String avatar;

  final String beratBadan;
  final String tinggiBadan;
  final String lingkarKepala;
  final String catatan;

  final String status;

  RiwayatPelayananModel({
    required this.id,
    required this.pesertaId,
    required this.name,
    required this.category,
    required this.date,
    required this.location,
    required this.avatar,
    required this.beratBadan,
    required this.tinggiBadan,
    required this.lingkarKepala,
    required this.catatan,
    required this.status,
  });

  factory RiwayatPelayananModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final peserta =
        json['peserta'] as Map<String, dynamic>? ?? {};

    final jadwal =
        json['jadwal'] as Map<String, dynamic>? ?? {};

    return RiwayatPelayananModel(
      id: json['id']?.toString() ?? '',
      pesertaId: json['pesertaId']?.toString() ?? '',

      name: peserta['nama']?.toString() ?? '-',

      category: _formatKategori(
        peserta['kategori']?.toString() ?? '',
      ),

      date: _formatTanggal(
        json['tanggalPemeriksaan']?.toString() ?? '',
      ),

      location: jadwal['lokasi']?.toString() ?? '-',

      avatar: 'assets/images/avatar_raka.png',

      beratBadan: _formatNilai(
        json['beratBadan'],
        'kg',
      ),

      tinggiBadan: _formatNilai(
        json['tinggiBadan'],
        'cm',
      ),

      lingkarKepala: _formatNilai(
        json['lingkarKepala'],
        'cm',
      ),

      catatan: json['catatan']?.toString() ?? '-',

      status: json['statusPemeriksaan']?.toString() ?? '',
    );
  }

  static String _formatKategori(String kategori) {
    switch (kategori.toUpperCase()) {
      case 'BALITA':
        return 'Balita';

      case 'IBU_HAMIL':
        return 'Ibu Hamil';

      case 'LANSIA':
        return 'Lansia';

      default:
        return kategori;
    }
  }

  static String _formatNilai(
    dynamic nilai,
    String satuan,
  ) {
    if (nilai == null) return '-';

    return '$nilai $satuan';
  }

  static String _formatTanggal(String tanggal) {
    if (tanggal.isEmpty) return '-';

    final parsed = DateTime.tryParse(tanggal);

    if (parsed == null) return tanggal;

    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${parsed.day} ${bulan[parsed.month - 1]} ${parsed.year}';
  }
}