class PendaftaranModel {
  final String nik;
  final String nama;
  final String tanggalLahir;
  final String jenisKelamin;
  final String kategori;
  final String alamat;
  final String noTelepon;

  PendaftaranModel({
    required this.nik,
    required this.nama,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.kategori,
    required this.alamat,
    required this.noTelepon,
  });

  Map<String, dynamic> toJson() {
    return {
      'nik': nik,
      'nama': nama,
      'tanggalLahir': tanggalLahir,
      'jenisKelamin': jenisKelamin,
      'kategori': kategori,
      'alamat': alamat,
      'noTelepon': noTelepon,
    };
  }

  factory PendaftaranModel.fromJson(Map<String, dynamic> json) {
    return PendaftaranModel(
      nik: json['nik']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      tanggalLahir: json['tanggalLahir']?.toString() ?? '',
      jenisKelamin: json['jenisKelamin']?.toString() ?? '',
      kategori: json['kategori']?.toString() ?? '',
      alamat: json['alamat']?.toString() ?? '',
      noTelepon: json['noTelepon']?.toString() ?? '',
    );
  }
}

/// Model data yang ditampilkan pada halaman Pendaftaran Berhasil.
class PendaftaranBerhasilModel {
  final String namaPeserta;
  final String kategori;
  final String keteranganKategori;
  final String tanggal;
  final String waktu;
  final String lokasi;
  final String nomorAntrean;
  final String antreanId;

  const PendaftaranBerhasilModel({
    required this.namaPeserta,
    required this.kategori,
    required this.keteranganKategori,
    required this.tanggal,
    required this.waktu,
    required this.lokasi,
    required this.nomorAntrean,
    required this.antreanId,
  });

  /// Label layanan sesuai kategori peserta.
  String get namaLayanan {
    switch (kategori.toUpperCase()) {
      case 'BALITA':
        return 'Pelayanan Balita';
      case 'IBU_HAMIL':
        return 'Pelayanan Ibu Hamil';
      case 'LANSIA':
        return 'Pelayanan Lansia';
      default:
        return 'Pelayanan Posyandu';
    }
  }

  /// Avatar peserta sesuai kategori.
  String get avatarPeserta {
    switch (kategori.toUpperCase()) {
      case 'BALITA':
        return 'assets/images/avatar_raka.png';
      case 'IBU_HAMIL':
        return 'assets/images/avatar_siti.png';
      case 'LANSIA':
        return 'assets/images/avatar_sari.png';
      default:
        return 'assets/images/avatar_4.png';
    }
  }

  /// Icon layanan sesuai kategori.
  String? get iconLayanan {
    switch (kategori.toUpperCase()) {
      case 'BALITA':
        return 'assets/images/icon_balita_pendaftaran.png';
      case 'IBU_HAMIL':
        return 'assets/images/icon_ibuhamil.png';
      case 'LANSIA':
        return 'assets/images/icon_lansia_pendaftaran.png';
      default:
        return null;
    }
  }
}
