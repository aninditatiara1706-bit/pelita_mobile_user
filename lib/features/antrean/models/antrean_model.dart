class AntreanModel {
  final String tanggal;
  final String waktu;
  final String namaPeserta;
  final String nomorAntrean;
  final String namaPosyandu;

  const AntreanModel({
    required this.tanggal,
    required this.waktu,
    required this.namaPeserta,
    this.nomorAntrean = 'A-12',
    this.namaPosyandu = 'Posyandu Rw 03',
  });

  String get layanan {
    return namaPeserta.toLowerCase() == 'sari'
        ? 'Pemeriksaan Lansia'
        : 'Pemeriksaan Balita';
  }

  String get nomorSedangDilayani => 'A-08';

  String get estimasi => 'Sekitar 40 Menit Lagi';
}