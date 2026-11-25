import 'package:flutter/foundation.dart';
import '../../profil peserta/models/peserta_model.dart';
import '../repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({ProfileRepository? repository}) : _repository=repository ?? ProfileRepository();
  final ProfileRepository _repository;

  String nama='', telepon='', email='';
  String avatarProfil='assets/images/avatar_siti.png';
  bool loadingProfil=true, loadingPeserta=true;
  String? errorProfil, errorPeserta;
  List<Peserta> daftarPeserta=[];

  Future<void> loadAll() async { await Future.wait([loadProfil(),loadPeserta()]); }
  Future<void> loadProfil() async {
    loadingProfil=true; errorProfil=null; notifyListeners();
    try {
      final data=await _repository.getProfile();
      nama=data.nama; telepon=data.telepon; email=data.email; avatarProfil=data.avatar;
    } catch(e) { errorProfil=e.toString(); }
    loadingProfil=false; notifyListeners();
  }
  Future<void> loadPeserta() async {
    loadingPeserta=true; errorPeserta=null; notifyListeners();
    try { daftarPeserta=await _repository.getParticipants(); }
    catch(e) { errorPeserta=e.toString(); }
    loadingPeserta=false; notifyListeners();
  }
}
