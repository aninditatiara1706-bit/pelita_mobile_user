class DashboardUser {
  final String nama;

  const DashboardUser({
    required this.nama,
  });

  factory DashboardUser.fromJson(Map<String, dynamic> json) {
    return DashboardUser(
      nama: json['name']?.toString() ?? 'Pengguna',
    );
  }
}

class GrowthRecord {
  final DateTime tanggal;
  final double? berat;
  final double? tinggi;
  final double? lingkarKepala;

  const GrowthRecord({
    required this.tanggal,
    this.berat,
    this.tinggi,
    this.lingkarKepala,
  });

  factory GrowthRecord.fromJson(Map<String, dynamic> json) {
    return GrowthRecord(
      tanggal: DateTime.parse(
        json['tanggalPemeriksaan'].toString(),
      ),
      berat: _toDouble(json['beratBadan']),
      tinggi: _toDouble(json['tinggiBadan']),
      lingkarKepala: _toDouble(json['lingkarKepala']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;

    if (value is num) return value.toDouble();

    return double.tryParse(value.toString());
  }
}