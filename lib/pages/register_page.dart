import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  void dispose() {
    namaController.dispose();
    hpController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  TextStyle get fieldTextStyle => GoogleFonts.poppins(
        fontSize: 12,
        color: Colors.black,
      );

  InputDecoration inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        fontSize: 10,
        color: Colors.black54,
      ),
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: Color(0xFFD9D9D9),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: Color(0xFFD9D9D9),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: Color(0xFFB34ABF),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      errorStyle: GoogleFonts.poppins(
        fontSize: 10,
        color: Colors.red,
      ),
    );
  }

  void daftar() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Form valid. Registrasi belum terhubung ke backend.',
          style: GoogleFonts.poppins(fontSize: 12),
        ),
      ),
    );
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

                    TextFormField(
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

                    const SizedBox(height: 13),

                    TextFormField(
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

                    const SizedBox(height: 13),

                    TextFormField(
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

                    const SizedBox(height: 13),

                    TextFormField(
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

                    const SizedBox(height: 13),

                    TextFormField(
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

                    const SizedBox(height: 38),

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
                          onPressed: daftar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            disabledBackgroundColor:
                                Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          child: Text(
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
                                color: Colors.black,
                                decoration: TextDecoration.underline,
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