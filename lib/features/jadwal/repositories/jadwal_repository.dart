import '../models/jadwal_model.dart';

class JadwalRepository {
  // ================================================
  // MENGAMBIL DATA JADWAL POSYANDU
  // ================================================

  Future<List<JadwalPosyandu>> ambilJadwal() async {
    return const [
      JadwalPosyandu(
        tanggal: '10 September 2026',
        waktu: '08.00 - 11.00 WIB',
      ),
    ];
  }
}
