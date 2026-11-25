class AntreanModel {
  // ID antrean dari backend
  final String id;

  final String tanggal;
  final String waktu;
  final String namaPeserta;
  final String nomorAntrean;
  final String namaPosyandu;
  final String nomorSedangDilayani;
  final String estimasi;

  // Data tambahan dari backend
  final String jadwalId;
  final String status;
  final String kategoriPeserta;
  final int nomorAntreanAngka;

  const AntreanModel({
    this.id = '',
    required this.tanggal,
    required this.waktu,
    required this.namaPeserta,
    required this.nomorAntrean,
    required this.namaPosyandu,
    required this.nomorSedangDilayani,
    required this.estimasi,
    this.jadwalId = '',
    this.status = 'MENUNGGU',
    this.kategoriPeserta = '',
    this.nomorAntreanAngka = 0,
  });

  String get layanan {
    switch (kategoriPeserta.toUpperCase()) {
      case 'LANSIA':
        return 'Pemeriksaan Lansia';

      case 'IBU_HAMIL':
        return 'Pemeriksaan Ibu Hamil';

      case 'BALITA':
        return 'Pemeriksaan Balita';

      default:
        return 'Pemeriksaan Posyandu';
    }
  }

  factory AntreanModel.fromJson(Map<String, dynamic> json) {
    final peserta = json['peserta'] is Map
        ? Map<String, dynamic>.from(json['peserta'])
        : <String, dynamic>{};

    final jadwal = json['jadwal'] is Map
        ? Map<String, dynamic>.from(json['jadwal'])
        : <String, dynamic>{};

    final posyandu = jadwal['posyandu'] is Map
        ? Map<String, dynamic>.from(jadwal['posyandu'])
        : <String, dynamic>{};

    // Ambil ID antrean dari backend
    final antreanId = json['id']?.toString() ?? '';

    // Ambil nomor antrean
    final nomorRaw = json['noAntrean'];

    final nomorAngka =
        int.tryParse(nomorRaw?.toString() ?? '') ?? 0;

    final deskripsi = jadwal['deskripsi']?.toString() ?? '';

    // Ambil waktu jadwal
    String waktu = jadwal['waktu']?.toString() ?? '';

    if (waktu.isEmpty) {
      final regex = RegExp(
        r'(\d{1,2}[:.]\d{2})\s*[-–]\s*(\d{1,2}[:.]\d{2})',
      );

      final match = regex.firstMatch(deskripsi);

      if (match != null) {
        waktu = '${match.group(1)} - ${match.group(2)}';
      } else {
        waktu = deskripsi;
      }
    }

    // Ambil nama posyandu
    final namaPosyandu =
        posyandu['nama']?.toString() ??
        jadwal['namaPosyandu']?.toString() ??
        jadwal['lokasi']?.toString() ??
        '';

    return AntreanModel(
      id: antreanId,

      tanggal: jadwal['tanggal']?.toString() ?? '',
      waktu: waktu,

      namaPeserta: peserta['nama']?.toString() ?? '',

      nomorAntrean: nomorAngka == 0
          ? (nomorRaw?.toString() ?? '')
          : 'A-${nomorAngka.toString().padLeft(2, '0')}',

      namaPosyandu: namaPosyandu,

      nomorSedangDilayani: '-',

      estimasi: 'Menunggu informasi antrean',

      jadwalId: jadwal['id']?.toString() ?? '',

      status: json['status']?.toString() ?? 'MENUNGGU',

      kategoriPeserta: peserta['kategori']?.toString() ?? '',

      nomorAntreanAngka: nomorAngka,
    );
  }

  AntreanModel copyWith({
    String? id,
    String? tanggal,
    String? waktu,
    String? namaPeserta,
    String? nomorAntrean,
    String? namaPosyandu,
    String? nomorSedangDilayani,
    String? estimasi,
    String? jadwalId,
    String? status,
    String? kategoriPeserta,
    int? nomorAntreanAngka,
  }) {
    return AntreanModel(
      id: id ?? this.id,

      tanggal: tanggal ?? this.tanggal,
      waktu: waktu ?? this.waktu,
      namaPeserta: namaPeserta ?? this.namaPeserta,
      nomorAntrean: nomorAntrean ?? this.nomorAntrean,
      namaPosyandu: namaPosyandu ?? this.namaPosyandu,

      nomorSedangDilayani:
          nomorSedangDilayani ?? this.nomorSedangDilayani,

      estimasi: estimasi ?? this.estimasi,

      jadwalId: jadwalId ?? this.jadwalId,
      status: status ?? this.status,
      kategoriPeserta:
          kategoriPeserta ?? this.kategoriPeserta,

      nomorAntreanAngka:
          nomorAntreanAngka ?? this.nomorAntreanAngka,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'tanggal': tanggal,
      'waktu': waktu,
      'namaPeserta': namaPeserta,
      'nomorAntrean': nomorAntrean,
      'namaPosyandu': namaPosyandu,
      'nomorSedangDilayani': nomorSedangDilayani,
      'estimasi': estimasi,

      'jadwalId': jadwalId,
      'status': status,
      'kategoriPeserta': kategoriPeserta,
      'nomorAntreanAngka': nomorAntreanAngka,
    };
  }
}