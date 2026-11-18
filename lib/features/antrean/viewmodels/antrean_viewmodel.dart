import '../models/antrean_model.dart';
import '../repositories/antrean_repository.dart';

class AntreanViewModel {
  final AntreanRepository repository;

  AntreanModel? _antrean;

  AntreanViewModel({
    required this.repository,
  });

  AntreanModel? get antrean => _antrean;

  void buatAntrean({
    required String tanggal,
    required String waktu,
    required String namaPeserta,
    String nomorAntrean = 'A-12',
    String namaPosyandu = 'Posyandu Rw 03',
  }) {
    _antrean = repository.buatAntrean(
      tanggal: tanggal,
      waktu: waktu,
      namaPeserta: namaPeserta,
      nomorAntrean: nomorAntrean,
      namaPosyandu: namaPosyandu,
    );
  }

  void setAntrean(AntreanModel antrean) {
    _antrean = repository.getAntreanTerakhir(antrean);
  }

  String get nomorAntrean =>
      _antrean?.nomorAntrean ?? 'A-12';

  String get namaPeserta =>
      _antrean?.namaPeserta ?? '';

  String get namaPosyandu =>
      _antrean?.namaPosyandu ?? '';

  String get tanggal =>
      _antrean?.tanggal ?? '';

  String get waktu =>
      _antrean?.waktu ?? '';

  String get layanan =>
      _antrean?.layanan ?? '';

  String get nomorSedangDilayani =>
      _antrean?.nomorSedangDilayani ?? 'A-08';

  String get estimasi =>
      _antrean?.estimasi ?? 'Sekitar 40 Menit Lagi';
}