
import '../models/posyandu_model.dart';

class PosyanduRepository {
  // ================================================
  // DATA PESERTA POSYANDU
  // ================================================

  Future<List<PesertaPosyandu>> ambilPeserta() async {
    return const [
      PesertaPosyandu(
        nama: 'Raka',
        keterangan: 'Balita 3 tahun',
        gambar: 'assets/images/avatar_raka.png',
      ),
      PesertaPosyandu(
        nama: 'Sari',
        keterangan: 'Lansia 65 Tahun',
        gambar: 'assets/images/avatar_sari.png',
      ),
    ];
  }
}
