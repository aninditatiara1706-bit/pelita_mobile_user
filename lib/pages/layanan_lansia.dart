import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pendaftaran_berhasil.dart';

class LayananLansiaPage extends StatefulWidget {
  const LayananLansiaPage({super.key});

  @override
  State<LayananLansiaPage> createState() => _LayananLansiaPageState();
}

class _LayananLansiaPageState extends State<LayananLansiaPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _nikController = TextEditingController();
  final _hpController = TextEditingController(); // Untuk Nomor Kontak
  final _namaWaliController = TextEditingController(); // Mengubah nama kontak menjadi wali
  final _hpWaliController = TextEditingController(); // Mengubah hp kontak menjadi wali
  String? _jenisKelamin;

  static const Color _purple = Color(0xFF9449B8);
  static const Color _pink = Color(0xFFE5507E);

  @override
  void dispose() {
    _namaController.dispose();
    _tanggalController.dispose();
    _nikController.dispose();
    _hpController.dispose();
    _namaWaliController.dispose();
    _hpWaliController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 60, now.month, now.day), // Default mundur 60 tahun untuk Lansia
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Pilih tanggal lahir',
      cancelText: 'BATAL',
      confirmText: 'PILIH',
    );
    if (selected != null) {
      _tanggalController.text =
          '${selected.day.toString().padLeft(2, '0')}/${selected.month.toString().padLeft(2, '0')}/${selected.year}';
    }
  }

  void _simpan() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (_jenisKelamin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih jenis kelamin.')),
      );
      return;
    }
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PendaftaranBerhasilPage(),
      ),
    );
  }

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
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 27),
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
                  constraints: BoxConstraints(minHeight: constraints.maxHeight - 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Tambah Peserta - Lansia',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 18, // Font diperbesar
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      _sectionTitle('Informasi Diri'),
                      _fieldLabel('Nama Lengkap'),
                      _textField(_namaController, 'Masukkan nama lengkap'),
                      
                      _fieldLabel('Tanggal Lahir'),
                      _dateField(),
                      
                      _fieldLabel('Jenis Kelamin'),
                      _genderSelector(),
                      
                      _fieldLabel('NIK'),
                      _textField(_nikController, 'Masukkan NIK', keyboardType: TextInputType.number, maxLength: 16),
                      
                      // Nomor Kontak ditambahkan di bawah NIK
                      _fieldLabel('Nomor Kontak'),
                      _textField(_hpController, 'Masukkan nomor kontak', keyboardType: TextInputType.phone),
                      
                      const SizedBox(height: 14),
                      
                      _sectionTitle('Informasi Wali'),
                      _fieldLabel('Nama Wali'),
                      _textField(_namaWaliController, 'Masukkan nama wali'),
                      
                      _fieldLabel('Nomor HP Wali'),
                      _textField(_hpWaliController, 'Masukkan nomor HP wali', keyboardType: TextInputType.phone),
                      
                      const SizedBox(height: 28),
                      
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
                            onPressed: _simpan,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
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
                            child: const Text('Simpan'),
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

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          text,
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      );

  Widget _fieldLabel(String text) => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 6),
        child: Text(
          text,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
        ),
      );

  Widget _textField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
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
          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            counterText: '',
            hintText: hint,
            hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide.none,
            ),
            errorStyle: GoogleFonts.poppins(fontSize: 12),
            errorMaxLines: 1,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) return 'Wajib diisi';
            if (maxLength != null && value.length != maxLength) return 'NIK harus $maxLength digit';
            return null;
          },
        ),
      ),
    );
  }

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
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.black45),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7), 
              borderSide: BorderSide.none,
            ),
            errorStyle: GoogleFonts.poppins(fontSize: 12),
          ),
          validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
        ),
      ),
    );
  }

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
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              onChanged: (value) => setState(() => _jenisKelamin = value),
            ),
          ),
          const SizedBox(width: 8),
          Text(value, style: GoogleFonts.poppins(fontSize: 14)),
        ],
      ),
    );
  }
}