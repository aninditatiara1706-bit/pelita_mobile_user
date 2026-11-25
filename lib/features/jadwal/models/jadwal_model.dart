class JadwalPosyandu {
  final String id;
  final String tanggal;
  final String waktu;
  final String lokasi;
  final String status;

  final int terisi;
  final int kuota;

  const JadwalPosyandu({
    required this.id,
    required this.tanggal,
    required this.waktu,
    required this.lokasi,
    required this.status,
    this.terisi = 0,
    this.kuota = 30,
  });

  int get sisaKuota => kuota - terisi;

  bool get penuh => terisi >= kuota;

  bool get tersedia => sisaKuota > 0;

  String get informasiKuota => '$terisi/$kuota';

  factory JadwalPosyandu.fromJson(Map<String, dynamic> json) {
    final count = json['_count'];

    int jumlahAntrean = 0;

    if (count is Map) {
      jumlahAntrean =
          int.tryParse(count['antrean']?.toString() ?? '0') ?? 0;
    }

    return JadwalPosyandu(
      id: json['id']?.toString() ?? '',
      tanggal: json['tanggal']?.toString() ?? '',
      waktu: json['waktu']?.toString() ?? '-',
      lokasi: json['lokasi']?.toString() ?? '-',
      status: json['status']?.toString() ?? '',
      terisi: jumlahAntrean,
      kuota: 30,
    );
  }
}