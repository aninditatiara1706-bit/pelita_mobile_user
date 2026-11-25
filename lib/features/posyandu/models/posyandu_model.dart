class PesertaPosyandu {
  final String id;
  final String nama;
  final String keterangan;
  final String gambar;

  final String kategori;
  final String tanggalLahir;
  final String jenisKelamin;

  const PesertaPosyandu({
    required this.id,
    required this.nama,
    required this.keterangan,
    required this.gambar,
    required this.kategori,
    required this.tanggalLahir,
    required this.jenisKelamin,
  });

  factory PesertaPosyandu.fromJson(Map<String, dynamic> json) {
    final kategori = (json['kategori'] ?? '').toString();

    return PesertaPosyandu(
      id: json['id'].toString(),
      nama: (json['nama'] ?? '').toString(),
      kategori: kategori,
      tanggalLahir: (json['tanggalLahir'] ?? '').toString(),
      jenisKelamin: (json['jenisKelamin'] ?? '').toString(),
      keterangan: kategori.replaceAll('_', ' '),
      gambar: _gambarKategori(kategori),
    );
  }

  static String _gambarKategori(String kategori) {
    switch (kategori.toUpperCase()) {
      case 'BALITA':
        return 'assets/images/avatar_raka.png';

      case 'IBU_HAMIL':
        return 'assets/images/avatar_ibu.png';

      case 'LANSIA':
        return 'assets/images/avatar_sari.png';

      default:
        return 'assets/images/avatar_raka.png';
    }
  }
}