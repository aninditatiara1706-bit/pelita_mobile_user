
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final hpController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;

  static const Color _purple = Color(0xFF9449B8);
  static const Color _pink = Color(0xFFE5507E);

  // URL BACKEND
  final String baseUrl = 'http://localhost:4000';

  @override
  void dispose() {
    namaController.dispose();
    hpController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // STYLE TEXT FIELD
  TextStyle get fieldTextStyle => GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.black,
      );

  // INPUT DECORATION
  InputDecoration inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.grey,
      ),
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide.none,
      ),
      errorStyle: GoogleFonts.poppins(
        fontSize: 12,
        color: Colors.red,
      ),
    );
  }

  // FIELD DENGAN BORDER GRADASI
  Widget gradientField({
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_purple, _pink],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(9),
      ),
      padding: const EdgeInsets.all(1.5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7.5),
        ),
        child: child,
      ),
    );
  }

  // ==========================================
  // REGISTER KE BACKEND
  // ==========================================
  Future<void> daftar() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse('$baseUrl/api/auth/register');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': namaController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text,
        }),
      );

      final Map<String, dynamic> responseData =
          response.body.isNotEmpty
              ? jsonDecode(response.body) as Map<String, dynamic>
              : {};

      if (!mounted) return;

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message'] ?? 'Registrasi berhasil!',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Arahkan pengguna ke halaman login
        await Future.delayed(
          const Duration(milliseconds: 800),
        );

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      } else {
        final message = responseData['message'] ??
            responseData['error'] ??
            'Registrasi gagal. Silakan coba kembali.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message.toString(),
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tidak dapat terhubung ke server. Periksa koneksi backend.',
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          backgroundColor: Colors.red,
        ),
      );

      debugPrint('Error register: $error');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 380,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 18),

                    // JUDUL
                    Text(
                      'Daftar Akun',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // NAMA LENGKAP
                    gradientField(
                      child: TextFormField(
                        controller: namaController,
                        style: fieldTextStyle,
                        textCapitalization: TextCapitalization.words,
                        decoration: inputStyle('Nama Lengkap'),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Nama lengkap wajib diisi';
                          }

                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 13),

                    // NOMOR HP
                    gradientField(
                      child: TextFormField(
                        controller: hpController,
                        keyboardType: TextInputType.phone,
                        style: fieldTextStyle,
                        decoration: inputStyle('No. HP'),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Nomor HP wajib diisi';
                          }

                          if (value.trim().length < 8) {
                            return 'Nomor HP terlalu pendek';
                          }

                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 13),

                    // EMAIL
                    gradientField(
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: fieldTextStyle,
                        decoration: inputStyle('Email'),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Email wajib diisi';
                          }

                          final email = value.trim();

                          if (!RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          ).hasMatch(email)) {
                            return 'Format email tidak valid';
                          }

                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 13),

                    // PASSWORD
                    gradientField(
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: hidePassword,
                        style: fieldTextStyle,
                        decoration: inputStyle('Password').copyWith(
                          suffixIcon: IconButton(
                            tooltip: hidePassword
                                ? 'Tampilkan password'
                                : 'Sembunyikan password',
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            icon: Icon(
                              hidePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 18,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password wajib diisi';
                          }

                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }

                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 13),

                    // CONFIRM PASSWORD
                    gradientField(
                      child: TextFormField(
                        controller: confirmPasswordController,
                        obscureText: hideConfirmPassword,
                        style: fieldTextStyle,
                        decoration: inputStyle(
                          'Confirm Password',
                        ).copyWith(
                          suffixIcon: IconButton(
                            tooltip: hideConfirmPassword
                                ? 'Tampilkan password'
                                : 'Sembunyikan password',
                            onPressed: () {
                              setState(() {
                                hideConfirmPassword =
                                    !hideConfirmPassword;
                              });
                            },
                            icon: Icon(
                              hideConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 18,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi password wajib diisi';
                          }

                          if (value != passwordController.text) {
                            return 'Password tidak sama';
                          }

                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 38),

                    // BUTTON DAFTAR
                    SizedBox(
                      height: 45,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF9146C6),
                              Color(0xFFE04491),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: ElevatedButton(
                          onPressed: isLoading ? null : daftar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            disabledBackgroundColor:
                                Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            disabledForegroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Daftar',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // NAVIGASI KE LOGIN
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text(
                            'Sudah Punya Akun? ',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Masuk',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: _purple,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
