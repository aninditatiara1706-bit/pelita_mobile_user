import '../models/antrean_model.dart';

class AntreanRepository {
  AntreanModel buatAntrean({
    required String tanggal,
    required String waktu,
    required String namaPeserta,
    String nomorAntrean = 'A-12',
    String namaPosyandu = 'Posyandu Rw 03',
  }) {
    return AntreanModel(
      tanggal: tanggal,
      waktu: waktu,
      namaPeserta: namaPeserta,
      nomorAntrean: nomorAntrean,
      namaPosyandu: namaPosyandu,
    );
  }

  AntreanModel? getAntreanTerakhir(
    AntreanModel antrean,
  ) {
    return antrean;
  }
}