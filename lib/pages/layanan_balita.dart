
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/auth_service.dart';
import 'pendaftaran_berhasil.dart';

class LayananBalitaPage extends StatefulWidget {
  const LayananBalitaPage({super.key});

  @override
  State<LayananBalitaPage> createState() => _LayananBalitaPageState();
}

class _LayananBalitaPageState extends State<LayananBalitaPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _nikController = TextEditingController();
  final _namaWaliController = TextEditingController();
  final _hpWaliController = TextEditingController();
  final _alamatController = TextEditingController();

  String? _jenisKelamin;
  bool _isLoading = false;

  static const Color _purple = Color(0xFF9449B8);
  static const Color _pink = Color(0xFFE5507E);

  // Backend tetap menggunakan port 4000
  static const String _baseUrl = 'http://localhost:4000';

  @override
  void dispose() {
    _namaController.dispose();
    _tanggalController.dispose();
    _nikController.dispose();
    _namaWaliController.dispose();
    _hpWaliController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  // ==========================================
  // PILIH TANGGAL LAHIR
  // ==========================================
  Future<void> _pilihTanggal() async {
    final now = DateTime.now();

    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 1, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Pilih tanggal lahir',
      cancelText: 'BATAL',
      confirmText: 'PILIH',
    );

    if (selected != null) {
      setState(() {
        _tanggalController.text =
            '${selected.day.toString().padLeft(2, '0')}/'
            '${selected.month.toString().padLeft(2, '0')}/'
            '${selected.year}';
      });
    }
  }

  // ==========================================
  // SIMPAN DATA KE BACKEND
  // ==========================================
  Future<void> _simpan() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_jenisKelamin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih jenis kelamin.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Konversi tanggal DD/MM/YYYY menjadi YYYY-MM-DD
      final tanggal = _tanggalController.text.split('/');

      final tanggalLahir =
          '${tanggal[2]}-${tanggal[1]}-${tanggal[0]}';

      // Konversi jenis kelamin sesuai enum Prisma
      final jenisKelamin = _jenisKelamin == 'Laki-laki'
          ? 'LAKI_LAKI'
          : 'PEREMPUAN';

      final url = Uri.parse('$_baseUrl/api/peserta');

      // Gunakan BrowserClient yang sama dengan AuthService.
      // withCredentials = true akan mengirim cookie login.
      final response = await AuthService.client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'nik': _nikController.text.trim(),
              'nama': _namaController.text.trim(),
              'tanggalLahir': tanggalLahir,
              'jenisKelamin': jenisKelamin,
              'kategori': 'BALITA',
              'alamat': _alamatController.text.trim(),
              'noTelepon': _hpWaliController.text.trim(),
            }),
          )
          .timeout(const Duration(seconds: 15));

      // Membaca respons backend
      Map<String, dynamic> responseData = {};

      if (response.body.isNotEmpty) {
        try {
          final decoded = jsonDecode(response.body);

          if (decoded is Map<String, dynamic>) {
            responseData = decoded;
          }
        } catch (_) {
          debugPrint('Respons server bukan JSON: ${response.body}');
        }
      }

      if (!mounted) return;

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message']?.toString() ??
                  'Pendaftaran balita berhasil disimpan!',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            backgroundColor: Colors.green,
          ),
        );

        await Future.delayed(
          const Duration(milliseconds: 700),
        );

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const PendaftaranBerhasilPage(),
          ),
        );
      } else {
        final message = responseData['message'] ??
            responseData['error'] ??
            'Gagal menyimpan data balita.';

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

      debugPrint('Error simpan balita: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ==========================================
  // BUILD UI
  // ==========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leadingWidth: 48,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 27,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Kembali',
        ),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 2, 20, 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 22,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Tambah Peserta - Balita',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      _sectionTitle('Informasi Diri'),

                      _fieldLabel('Nama Lengkap'),
                      _textField(
                        _namaController,
                        'Masukkan nama lengkap',
                      ),

                      _fieldLabel('Tanggal Lahir'),
                      _dateField(),

                      _fieldLabel('Jenis Kelamin'),
                      _genderSelector(),

                      _fieldLabel('NIK'),
                      _textField(
                        _nikController,
                        'Masukkan NIK',
                        keyboardType: TextInputType.number,
                        maxLength: 16,
                      ),

                      // FIELD ALAMAT
                      _fieldLabel('Alamat'),
                      _textField(
                        _alamatController,
                        'Masukkan alamat lengkap',
                        maxLines: 3,
                      ),

                      const SizedBox(height: 14),

                      _sectionTitle('Informasi Orang Tua/Wali'),

                      _fieldLabel('Nama Orang Tua/Wali'),
                      _textField(
                        _namaWaliController,
                        'Masukkan nama orang tua/wali',
                      ),

                      _fieldLabel('Nomor HP Orang Tua/Wali'),
                      _textField(
                        _hpWaliController,
                        'Masukkan nomor HP',
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 28),

                      // BUTTON SIMPAN
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [_purple, _pink],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _simpan,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              disabledBackgroundColor:
                                  Colors.transparent,
                              foregroundColor: Colors.white,
                              disabledForegroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 21,
                                    width: 21,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Simpan'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ==========================================
  // SECTION TITLE
  // ==========================================
  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      );

  // ==========================================
  // FIELD LABEL
  // ==========================================
  Widget _fieldLabel(String text) => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 6),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      );

  // ==========================================
  // TEXT FIELD
  // ==========================================
  Widget _textField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    int maxLines = 1,
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
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          maxLines: maxLines,
          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            counterText: '',
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
            errorStyle: GoogleFonts.poppins(fontSize: 12),
            errorMaxLines: 1,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Wajib diisi';
            }

            if (maxLength != null) {
              if (value.length != maxLength ||
                  !RegExp(r'^\d+$').hasMatch(value)) {
                return 'NIK harus $maxLength digit angka';
              }
            }

            return null;
          },
        ),
      ),
    );
  }

  // ==========================================
  // DATE FIELD
  // ==========================================
  Widget _dateField() {
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
        child: TextFormField(
          controller: _tanggalController,
          readOnly: true,
          onTap: _pilihTanggal,
          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            suffixIcon: const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: Colors.black45,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide.none,
            ),
            errorStyle: GoogleFonts.poppins(fontSize: 12),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Wajib diisi' : null,
        ),
      ),
    );
  }

  // ==========================================
  // GENDER SELECTOR
  // ==========================================
  Widget _genderSelector() {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Row(
        children: [
          _genderOption('Laki-laki'),
          const SizedBox(width: 24),
          _genderOption('Perempuan'),
        ],
      ),
    );
  }

  Widget _genderOption(String value) {
    return InkWell(
      onTap: () => setState(() => _jenisKelamin = value),
      borderRadius: BorderRadius.circular(20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 24,
            child: Radio<String>(
              value: value,
              groupValue: _jenisKelamin,
              activeColor: _purple,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(
                horizontal: -4,
                vertical: -4,
              ),
              onChanged: (value) {
                setState(() => _jenisKelamin = value);
              },
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
