import '../../../services/peserta_service.dart';

class ProfilPesertaRepository {
  final PesertaService _pesertaService;

  ProfilPesertaRepository({
    PesertaService? pesertaService,
  }) : _pesertaService = pesertaService ?? PesertaService();

  Future<Map<String, dynamic>> getDetailPeserta(
    String pesertaId,
  ) async {
    final result = await _pesertaService.getParticipantDetail(
      pesertaId,
    );

    return Map<String, dynamic>.from(result);
  }
}