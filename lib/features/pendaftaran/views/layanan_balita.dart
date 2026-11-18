import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/pendaftaran_model.dart';
import '../viewmodels/pendaftaran_viewmodels.dart';
import '../../../pages/pendaftaran_berhasil.dart';

class LayananBalitaPage extends StatefulWidget {
  const LayananBalitaPage({super.key});

  @override
  State<LayananBalitaPage> createState() => _LayananBalitaPageState();
}

class _LayananBalitaPageState extends State<LayananBalitaPage> {
  final _formKey = GlobalKey<FormState>();
  final _vm = PendaftaranViewModels();

  final _nama = TextEditingController();
  final _tanggal = TextEditingController();
  final _nik = TextEditingController();
  final _namaWali = TextEditingController();
  final _hpWali = TextEditingController();
  final _alamat = TextEditingController();

  String? _jenisKelamin;

  static const Color purple = Color(0xFF9449B8);
  static const Color pink = Color(0xFFE5507E);

  @override
  void dispose() {
    _vm.dispose();
    _nama.dispose();
    _tanggal.dispose();
    _nik.dispose();
    _namaWali.dispose();
    _hpWali.dispose();
    _alamat.dispose();
    super.dispose();
  }

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
      _tanggal.text =
          '${selected.day.toString().padLeft(2, '0')}/'
          '${selected.month.toString().padLeft(2, '0')}/'
          '${selected.year}';
    }
  }

  Future<void> _simpan() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (_jenisKelamin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih jenis kelamin.')),
      );
      return;
    }

    final tanggal = _tanggal.text.split('/');

    final data = PendaftaranModel(
      nik: _nik.text.trim(),
      nama: _nama.text.trim(),
      tanggalLahir: '${tanggal[2]}-${tanggal[1]}-${tanggal[0]}',
      jenisKelamin: _jenisKelamin == 'Laki-laki' ? 'LAKI_LAKI' : 'PEREMPUAN',
      kategori: 'BALITA',
      alamat: _alamat.text.trim(),
      noTelepon: _hpWali.text.trim(),
    );

    final berhasil = await _vm.simpanPendaftaran(data);

    if (!mounted) return;

    if (berhasil) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_vm.successMessage!),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 700));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PendaftaranBerhasilPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_vm.errorMessage ?? 'Pendaftaran gagal.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 14)),
    );
  }

  Widget _field(
    TextEditingController controller,
    String hint, {
    TextInputType keyboard = TextInputType.text,
    int? maxLength,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [purple, pink]),
        borderRadius: BorderRadius.circular(9),
      ),
      padding: const EdgeInsets.all(1.5),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        maxLength: maxLength,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          counterText: '',
          hintText: hint,
          hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          suffixIcon: readOnly
              ? const Icon(Icons.calendar_today_outlined)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide.none,
          ),
          errorStyle: GoogleFonts.poppins(fontSize: 12),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Wajib diisi';
          }

          if (maxLength != null &&
              (value.length != maxLength ||
                  !RegExp(r'^\d+$').hasMatch(value))) {
            return 'NIK harus 16 digit angka';
          }

          return null;
        },
      ),
    );
  }

  Widget _gender() {
    return Row(
      children: ['Laki-laki', 'Perempuan'].map((value) {
        return Expanded(
          child: RadioListTile<String>(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(value, style: GoogleFonts.poppins(fontSize: 12)),
            value: value,
            groupValue: _jenisKelamin,
            activeColor: purple,
            onChanged: (v) {
              setState(() => _jenisKelamin = v);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _section(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SafeArea(
        top: false,
        child: AnimatedBuilder(
          animation: _vm,
          builder: (context, child) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 2, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Tambah Peserta - Balita',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _section('Informasi Diri'),

                    _label('Nama Lengkap'),
                    _field(_nama, 'Masukkan nama lengkap'),

                    _label('Tanggal Lahir'),
                    _field(
                      _tanggal,
                      'Pilih tanggal lahir',
                      readOnly: true,
                      onTap: _pilihTanggal,
                    ),

                    _label('Jenis Kelamin'),
                    _gender(),

                    _label('NIK'),
                    _field(
                      _nik,
                      'Masukkan NIK',
                      keyboard: TextInputType.number,
                      maxLength: 16,
                    ),

                    _label('Alamat'),
                    _field(_alamat, 'Masukkan alamat lengkap', maxLines: 3),

                    const SizedBox(height: 14),

                    _section('Informasi Orang Tua/Wali'),

                    _label('Nama Orang Tua/Wali'),
                    _field(_namaWali, 'Masukkan nama orang tua/wali'),

                    _label('Nomor HP Orang Tua/Wali'),
                    _field(
                      _hpWali,
                      'Masukkan nomor HP',
                      keyboard: TextInputType.phone,
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [purple, pink],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: _vm.isLoading ? null : _simpan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            disabledBackgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                          ),
                          child: _vm.isLoading
                              ? const SizedBox(
                                  height: 21,
                                  width: 21,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Simpan',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
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
    );
  }
}
