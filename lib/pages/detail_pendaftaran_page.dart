import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pendaftaran_berhasil_page.dart';

class DetailPendaftaranPage extends StatelessWidget {
  final String namaPeserta;
  final String tanggal;
  final String waktu;

  const DetailPendaftaranPage({
    super.key,
    required this.namaPeserta,
    required this.tanggal,
    required this.waktu,
  });

  @override
  Widget build(BuildContext context) {

    final isRaka = namaPeserta.toLowerCase() == 'raka';

    final keterangan =
    isRaka ? 'Balita 3 Tahun' : 'Lansia 65 Tahun';

    final gambar = isRaka
        ? 'assets/images/avatar_raka.png'
        : 'assets/images/avatar_sari.png';

    final layanan =
    isRaka ? 'Pelayanan Balita' : 'Pelayanan Lansia';

    const ungu = Color(0xFFD24BD8);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),

                        IconButton(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),

                        const SizedBox(height: 24),

                        Center(
                          child: Text(
                            'Detail Pendaftaran',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(17),
                            border: Border.all(
                              color: const Color(0xFF555555),
                              width: 0.9,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 34,
                                backgroundColor:
                                    const Color(0xFFF2F2F2),
                                backgroundImage:
                                    AssetImage(gambar),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      namaPeserta,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      keterangan,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(17),
                            border: Border.all(
                              color: const Color(0xFF555555),
                              width: 0.9,
                            ),
                          ),
                          child: Column(
                            children: [
                              _detailRow(
  icon: Icons.child_care,
  imagePath: isRaka
      ? 'assets/images/icon_balita_pendaftaran.png'
      : 'assets/images/icon_lansia_pendaftaran.png',
  judul: 'Layanan',
  isi: layanan,
),
                              const SizedBox(height: 19),
                              _detailRow(
                                icon: Icons.calendar_month_outlined,
                                judul: 'Jadwal',
                                isi: '$tanggal\n$waktu',
                              ),
                              const SizedBox(height: 19),
                              _detailRow(
                                icon: Icons.location_on,
                                judul: 'Lokasi',
                                isi: 'Posyandu Melati',
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                       const SizedBox(height: 18),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 17,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF555555),
                              width: 0.9,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: ungu,
                                size: 27,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Data Peserta akan digunakan '
                                  'secara otomatis sesuai dengan '
                                  'informasi yang telah terdaftar.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.black,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

const SizedBox(height: 36),

                        Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF9148D8),
                                Color(0xFFE0468F),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(16),
                              
onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PendaftaranBerhasilPage(
        namaPeserta: namaPeserta,
        tanggal: tanggal,
        waktu: waktu,
      ),
    ),
  );
},

                              child: Center(
                                child: Text(
                                  'Daftar Posyandu',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight:
                                        FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
Widget _detailRow({
  required IconData icon,
  String? imagePath,
  required String judul,
  required String isi,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 32,
        height: 34,
        child: imagePath != null
            ? Image.asset(
                imagePath,
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              )
            : Icon(
                icon,
                size: 30,
                color: const Color(0xFFD24BD8),
              ),
      ),

      const SizedBox(width: 12),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              judul,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            Text(
              isi,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

}