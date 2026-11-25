import 'package:flutter/foundation.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();

  // =========================
  // STATE
  // =========================
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // =========================
  // LOGIN
  // =========================
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      final result = await _authRepository.login(
        email: email,
        password: password,
      );

      return result;
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // REGISTER
  // =========================
  Future<Map<String, dynamic>> register({
    required String name,
    required String telepon,
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      final result = await _authRepository.register(
        name: name,
        telepon: telepon,
        email: email,
        password: password,
      );

      return result;
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authRepository.logout();
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // LOADING HELPER
  // =========================
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}