import 'pendaftaran_berhasil_page.dart' as booking;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PendaftaranBerhasilPage extends StatefulWidget {
  const PendaftaranBerhasilPage({super.key});

  @override
  State<PendaftaranBerhasilPage> createState() => _PendaftaranBerhasilPageState();
}

class _PendaftaranBerhasilPageState extends State<PendaftaranBerhasilPage>
     {
  static const Color _purple = Color(0xFF9449B8);
  static const Color _pink = Color(0xFFE5507E);
  
  

  void _kembaliKeHome(BuildContext context) {
    Navigator.of(context).popUntil((route) {
      return route.isFirst ||
          route.settings.name == '/dashboard' ||
          route.settings.name == '/beranda';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const booking.AnimatedSuccessCheck(),
                const SizedBox(height: 24),
                Text(
                  'Pendaftaran Berhasil!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 22, 
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Data Peserta\nBerhasil Ditambahkan', 
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14, 
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700], 
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50, 
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
                      onPressed: () => _kembaliKeHome(context),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Kembali ke Home',
                        style: GoogleFonts.poppins(
                          fontSize: 16, 
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


