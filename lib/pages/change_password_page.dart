
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _oldPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _showOld = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _saving = false;

  static const pink = Color(0xFFE0468F);
  static const purple = Color(0xFF9449B8);

  // Password simulasi untuk demo UTS.
  // Tidak digunakan untuk autentikasi sungguhan.
  static const String demoPassword = 'Pelita123';

  bool get hasMinLength => _newPassword.text.length >= 8;
  bool get hasLetter =>
      RegExp(r'[a-zA-Z]').hasMatch(_newPassword.text);
  bool get hasNumber =>
      RegExp(r'[0-9]').hasMatch(_newPassword.text);

  @override
  void initState() {
    super.initState();
    _newPassword.addListener(_refresh);
  }

  void _refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    _newPassword.removeListener(_refresh);
    _oldPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  InputDecoration _decoration(
    String hint,
    bool visible,
    VoidCallback toggle,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: purple, width: 1.5),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: Colors.grey.shade600,
        ),
        onPressed: toggle,
      ),
    );
  }

  Widget _passwordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool visible,
    required VoidCallback toggle,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: !visible,
          autocorrect: false,
          enableSuggestions: false,
          decoration: _decoration(hint, visible, toggle),
          validator: validator,
        ),
      ],
    );
  }

  Widget _requirement(String text, bool valid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            valid ? Icons.check_circle : Icons.circle_outlined,
            color: valid ? Colors.green : Colors.grey,
            size: 18,
          ),
          const SizedBox(width: 9),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: valid ? Colors.green.shade700 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  void _savePassword() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    // Simulasi UTS: validasi berhasil, tanpa mengubah
    // password pada server atau sistem autentikasi.
    setState(() => _saving = false);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text('Validasi Berhasil'),
          ],
        ),
        content: const Text(
          'Kata sandi baru telah memenuhi persyaratan. '
          'Ini masih simulasi UTS, sehingga kata sandi '
          'akun sebenarnya belum diubah.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FC),
      appBar: AppBar(
        title: const Text(
          'Ubah Kata Sandi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: purple,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [purple, pink],
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Column(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.lock_reset,
                            color: purple,
                            size: 40,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Keamanan Akun',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Perbarui kata sandi untuk menjaga keamanan akun PELITA.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Kartu Form
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _passwordField(
                          label: 'Kata Sandi Saat Ini',
                          hint: 'Masukkan kata sandi saat ini',
                          controller: _oldPassword,
                          visible: _showOld,
                          toggle: () => setState(
                            () => _showOld = !_showOld,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kata sandi saat ini wajib diisi';
                            }
                            if (value != demoPassword) {
                              return 'Kata sandi simulasi tidak sesuai';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 22),

                        _passwordField(
                          label: 'Kata Sandi Baru',
                          hint: 'Masukkan kata sandi baru',
                          controller: _newPassword,
                          visible: _showNew,
                          toggle: () => setState(
                            () => _showNew = !_showNew,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kata sandi baru wajib diisi';
                            }
                            if (!hasMinLength || !hasLetter || !hasNumber) {
                              return 'Kata sandi belum memenuhi persyaratan';
                            }
                            if (value == _oldPassword.text) {
                              return 'Harus berbeda dari kata sandi lama';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 22),

                        _passwordField(
                          label: 'Konfirmasi Kata Sandi Baru',
                          hint: 'Ulangi kata sandi baru',
                          controller: _confirmPassword,
                          visible: _showConfirm,
                          toggle: () => setState(
                            () => _showConfirm = !_showConfirm,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Konfirmasi wajib diisi';
                            }
                            if (value != _newPassword.text) {
                              return 'Konfirmasi kata sandi tidak cocok';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Indikator Keamanan
                  Container(
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5EAF9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.shield_outlined, color: purple),
                            SizedBox(width: 8),
                            Text(
                              'Persyaratan Kata Sandi',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _requirement(
                          'Minimal 8 karakter',
                          hasMinLength,
                        ),
                        _requirement(
                          'Mengandung huruf',
                          hasLetter,
                        ),
                        _requirement(
                          'Mengandung angka',
                          hasNumber,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _savePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pink,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        _saving ? 'Memproses...' : 'Simpan Kata Sandi',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  const Text(
                    'Demo UTS • Perubahan kata sandi masih berupa simulasi.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
