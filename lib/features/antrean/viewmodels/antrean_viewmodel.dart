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
    required String nomorAntrean,
    required String namaPosyandu,
    required String nomorSedangDilayani,
    required String estimasi,
  }) {
    _antrean = repository.buatAntrean(
      tanggal: tanggal,
      waktu: waktu,
      namaPeserta: namaPeserta,
      nomorAntrean: nomorAntrean,
      namaPosyandu: namaPosyandu,
      nomorSedangDilayani: nomorSedangDilayani,
      estimasi: estimasi,
    );
  }

  void setAntrean(AntreanModel data) {
    _antrean = data;
  }

  String get nomorAntrean => _antrean?.nomorAntrean ?? '';

  String get namaPeserta => _antrean?.namaPeserta ?? '';

  String get namaPosyandu => _antrean?.namaPosyandu ?? '';

  String get tanggal => _antrean?.tanggal ?? '';

  String get waktu => _antrean?.waktu ?? '';

  String get layanan => _antrean?.layanan ?? '';

  String get nomorSedangDilayani =>
      _antrean?.nomorSedangDilayani ?? '';

  String get estimasi => _antrean?.estimasi ?? '';
}