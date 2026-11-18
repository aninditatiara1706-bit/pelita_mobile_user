class NotificationData {
  final List<AntreanNotification> antrean;
  final List<JadwalNotification> jadwal;

  const NotificationData({required this.antrean, required this.jadwal});
}

class AntreanNotification {
  final String namaPeserta;
  final String nomorAntrean;
  final String status;
  final String tanggal;

  const AntreanNotification({
    required this.namaPeserta,
    required this.nomorAntrean,
    required this.status,
    required this.tanggal,
  });

  factory AntreanNotification.fromJson(Map<String, dynamic> json) {
    final peserta = json['peserta'] is Map
        ? Map<String, dynamic>.from(json['peserta'] as Map)
        : const <String, dynamic>{};
    final jadwal = json['jadwal'] is Map
        ? Map<String, dynamic>.from(json['jadwal'] as Map)
        : const <String, dynamic>{};

    return AntreanNotification(
      namaPeserta: (peserta['nama'] ?? json['namaPeserta'] ?? 'Peserta')
          .toString(),
      nomorAntrean: (json['noAntrean'] ?? json['nomorAntrean'] ?? '-')
          .toString(),
      status: (json['status'] ?? 'MENUNGGU').toString(),
      tanggal: (jadwal['tanggal'] ?? json['tanggal'] ?? '').toString(),
    );
  }
}

class JadwalNotification {
  final String namaPosyandu;
  final String jamMulai;
  final String jamSelesai;
  final String lokasi;

  const JadwalNotification({
    required this.namaPosyandu,
    required this.jamMulai,
    required this.jamSelesai,
    required this.lokasi,
  });

  factory JadwalNotification.fromJson(Map<String, dynamic> json) {
    return JadwalNotification(
      namaPosyandu: (json['namaPosyandu'] ?? json['nama'] ?? 'Posyandu')
          .toString(),
      jamMulai: (json['jamMulai'] ?? '').toString(),
      jamSelesai: (json['jamSelesai'] ?? '').toString(),
      lokasi: (json['lokasi'] ?? json['alamat'] ?? '').toString(),
    );
  }
}
