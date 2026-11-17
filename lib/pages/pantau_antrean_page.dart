import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/auth_service.dart';

class PantauAntreanPage extends StatefulWidget {
  final String? antreanId;

  const PantauAntreanPage({super.key, this.antreanId});

  @override
  State<PantauAntreanPage> createState() => _PantauAntreanPageState();
}

class _PantauAntreanPageState extends State<PantauAntreanPage> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _antrean;

  @override
  void initState() {
    super.initState();
    _loadAntrean();
  }

  Future<void> _loadAntrean() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final path = widget.antreanId == null
          ? '${AuthService.baseUrl}/antrean/saya/aktif'
          : '${AuthService.baseUrl}/antrean/${widget.antreanId}';

      final response = await AuthService.client
          .get(Uri.parse(path))
          .timeout(const Duration(seconds: 15));

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 || responseData['success'] != true) {
        throw Exception(
          responseData['message'] ?? 'Gagal memuat status antrean.',
        );
      }

      final data = responseData['data'];
      Map<String, dynamic>? antrean;

      if (widget.antreanId != null) {
        antrean = Map<String, dynamic>.from(data as Map);
      } else if (data is List) {
        final activeQueues = data
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .where(
              (item) =>
                  item['status'] == 'MENUNGGU' ||
                  item['status'] == 'DIPERIKSA',
            )
            .toList();
        if (activeQueues.isNotEmpty) {
          antrean = activeQueues.first;
        }
      } else {
        throw const FormatException(
          'Format daftar antrean dari server tidak valid.',
        );
      }

      if (!mounted) return;

      setState(() {
        _antrean = antrean;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  String get _statusLabel => switch (_antrean?['status']) {
        'MENUNGGU' => 'Menunggu dipanggil',
        'DIPERIKSA' => 'Sedang diperiksa',
        'SELESAI' => 'Selesai',
        'BATAL' => 'Dibatalkan',
        _ => 'Status belum tersedia',
      };

  String get _nomorAntrean {
    final nomor = _antrean?['noAntrean'];
    if (nomor == null) return '-';
    return 'A-${nomor.toString().padLeft(2, '0')}';
  }

  String get _layanan {
    final peserta = _antrean?['peserta'];
    final kategori = peserta is Map
        ? (peserta['kategori'] ?? '').toString().toUpperCase()
        : '';

    return switch (kategori) {
      'BALITA' => 'Pemeriksaan Balita',
      'IBU_HAMIL' => 'Pemeriksaan Ibu Hamil',
      'LANSIA' => 'Pemeriksaan Lansia',
      _ => 'Pemeriksaan Posyandu',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: Colors.white,

  bottomNavigationBar: SafeArea(
    top: false,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(
        22,
        12,
        22,
        26,
      ),
      child: _buildCancelButton(
  (MediaQuery.sizeOf(context).width / 390)
      .clamp(0.82, 1.15)
      .toDouble(),
),
    ),
  ),

  body: SafeArea(
        child: LayoutBuilder(
          builder: (context, viewport) {
            // Ukuran dihitung dari lebar dan tinggi area yang benar-benar
            // tersedia setelah SafeArea, bukan dari tipe/merek perangkat.
            final screenWidth = viewport.maxWidth;
            final screenHeight = viewport.maxHeight;

            // Batasi lebar konten agar tidak terlalu melebar di tablet.
            final horizontalPadding = screenWidth < 350 ? 16.0 : 22.0;
            final contentWidth = (screenWidth - (horizontalPadding * 2))
                .clamp(260.0, 460.0)
                .toDouble();

            // Skala mengikuti lebar layar. Clamp menjaga ukuran tetap nyaman
            // di HP kecil dan tidak berlebihan di HP/tablet besar.
            final scale = (screenWidth / 390).clamp(0.82, 1.15).toDouble();

            // Jarak vertikal ikut menyesuaikan tinggi layar.
            final verticalScale =
                (screenHeight / 780).clamp(0.82, 1.08).toDouble();

            final waveHeight = (screenWidth * 0.36)
                .clamp(118.0, 158.0)
                .toDouble();

            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: waveHeight,
                  child: CustomPaint(painter: _PantauWavePainter()),
                ),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: contentWidth),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          0,
                          3 * verticalScale,
                          0,
                          24 * verticalScale,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(scale),

                            SizedBox(height: 28 * verticalScale),

                            _buildMainTicket(
                              scale: scale,
                              width: contentWidth * 0.88,
                            ),

                            SizedBox(height: 34 * verticalScale),

                            Text(
                              _antrean == null
                                  ? 'Antrean Saya'
                                  : _statusLabel,
                              style: GoogleFonts.poppins(
                                fontSize: 13 * scale,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),

                            SizedBox(height: 14 * verticalScale),

                            _buildStatus(scale),

                            SizedBox(height: 32 * verticalScale),

                            _buildInfoCard(
                              icon: Icons.access_time_outlined,
                              text: _antrean == null
                                  ? 'Estimasi Giliran\nBelum tersedia'
                                  : 'Status Antrean\n$_statusLabel',
                              scale: scale,
                            ),

                            SizedBox(height: 16 * verticalScale),

                            _buildInfoCard(
                              icon: Icons.info_outline,
                              text:
                                  'Informasi antrean\n'
                                  'Ditampilkan sesuai data\n'
                                  'yang tersedia dari server',
                              scale: scale,
                            ),

                            SizedBox(height: 112 * verticalScale),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: contentWidth),
                      child: _buildCancelButton(scale),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(double scale) {
    return Row(
      children: [
        SizedBox(
          width: 38 * scale,
          child: IconButton(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            constraints: BoxConstraints(
              minWidth: 38 * scale,
              minHeight: 42 * scale,
            ),
            icon: Icon(
              Icons.arrow_back,
              size: 25 * scale,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/dashboard',
                (route) => false,
              );
            },
          ),
        ),
        Expanded(
          child: Text(
            'Pantau Antrean',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14 * scale,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 38 * scale),
      ],
    );
  }

  Widget _buildMainTicket({
    required double scale,
    required double width,
  }) {
    final ticketWidth = width.clamp(245.0, 410.0).toDouble();

    return Center(
      child: CustomPaint(
        painter: _PantauTicketPainter(
          radius: 13 * scale,
          notchRadius: 11 * scale,
          strokeWidth: 1.3,
          fillColor: Colors.white,
        ),
        child: SizedBox(
          width: ticketWidth,
          height: 128 * scale,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Nomor Antrean Anda',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12 * scale,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 2 * scale),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFFB345D6),
                    Color(0xFFE04FBC),
                  ],
                ).createShader(bounds),
                blendMode: BlendMode.srcIn,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _nomorAntrean,
                    style: GoogleFonts.poppins(
                      fontSize: 62 * scale,
                      fontWeight: FontWeight.w800,
                      height: 1.05,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatus(double scale) {
    if (_isLoading) {
      return SizedBox(
        height: 52 * scale,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gagal memuat status antrean: $_error',
            style: GoogleFonts.poppins(fontSize: 12 * scale),
          ),
          TextButton(
            onPressed: _loadAntrean,
            child: const Text('Coba lagi'),
          ),
        ],
      );
    }

    if (_antrean == null) {
      return Text(
        'Belum ada antrean aktif pada akun ini.',
        style: GoogleFonts.poppins(fontSize: 13 * scale),
      );
    }

    return Row(
      children: [
        CustomPaint(
          painter: _PantauTicketPainter(
            radius: 7 * scale,
            notchRadius: 6 * scale,
            strokeWidth: 1,
            fillColor: Colors.white,
          ),
          child: SizedBox(
            width: 88 * scale,
            height: 52 * scale,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _nomorAntrean,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 25 * scale,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 11 * scale),
        Expanded(
          child: Text(
            _layanan,
            style: GoogleFonts.poppins(
              fontSize: 11 * scale,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String text,
    required double scale,
  }) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 70 * scale),
      padding: EdgeInsets.symmetric(
        horizontal: 14 * scale,
        vertical: 12 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8 * scale),
        border: Border.all(
          color: const Color(0xFF444444),
          width: 0.9,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFD54DDD),
            size: 27 * scale,
          ),
          SizedBox(width: 11 * scale),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 11 * scale,
                height: 1.4,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton(double scale) {
    return SizedBox(
      width: double.infinity,
      height: 48 * scale,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF9845C5),
              Color(0xFFE344A2),
            ],
          ),
          borderRadius: BorderRadius.circular(12 * scale),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12 * scale),
            onTap: _antrean == null
                ? null
                : () {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Fitur pembatalan antrean perlu dihubungkan ke server.',
                          ),
                        ),
                      );
                  },
            child: Center(
              child: Text(
                'Batalkan Antrean',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14 * scale,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PantauWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Rect.fromLTWH(0, 0, w, h);

    final dasar = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h * 0.75)
      ..cubicTo(w * 0.85, h * 0.59, w * 0.72, h * 0.40, w * 0.53, h * 0.49)
      ..cubicTo(w * 0.34, h * 0.60, w * 0.20, h * 0.76, 0, h * 0.58)
      ..close();

    canvas.drawPath(
      dasar,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE74C82),
            Color(0xFFD72BC5),
            Color(0xFFD52FD0),
          ],
        ).createShader(rect),
    );

    final atas = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..cubicTo(w * 0.77, h * 0.10, w * 0.62, h * 0.28, w * 0.40, h * 0.28)
      ..cubicTo(w * 0.23, h * 0.28, w * 0.10, h * 0.22, 0, h * 0.20)
      ..close();

    canvas.drawPath(
      atas,
      Paint()..color = const Color(0xFFAF21AC).withValues(alpha: 0.45),
    );

    final tengah = Path()
      ..moveTo(0, h * 0.30)
      ..cubicTo(w * 0.23, h * 0.43, w * 0.37, h * 0.45, w * 0.58, h * 0.32)
      ..cubicTo(w * 0.77, h * 0.20, w * 0.88, h * 0.19, w, h * 0.24)
      ..lineTo(w, h * 0.46)
      ..cubicTo(w * 0.75, h * 0.37, w * 0.61, h * 0.43, w * 0.43, h * 0.56)
      ..cubicTo(w * 0.20, h * 0.67, w * 0.11, h * 0.53, 0, h * 0.44)
      ..close();

    canvas.drawPath(
      tengah,
      Paint()..color = const Color(0xFFFF91D0).withValues(alpha: 0.40),
    );

    final bawah = Path()
      ..moveTo(0, h * 0.48)
      ..cubicTo(w * 0.21, h * 0.72, w * 0.40, h * 0.62, w * 0.61, h * 0.49)
      ..cubicTo(w * 0.79, h * 0.36, w * 0.89, h * 0.43, w, h * 0.51)
      ..lineTo(w, h * 0.75)
      ..cubicTo(w * 0.85, h * 0.59, w * 0.72, h * 0.40, w * 0.53, h * 0.49)
      ..cubicTo(w * 0.34, h * 0.60, w * 0.20, h * 0.76, 0, h * 0.58)
      ..close();

    canvas.drawPath(
      bawah,
      Paint()..color = const Color(0xFFF58ED3).withValues(alpha: 0.42),
    );
  }

  @override
  bool shouldRepaint(covariant _PantauWavePainter old) => false;
}

class _PantauTicketPainter extends CustomPainter {
  final double radius;
  final double notchRadius;
  final double strokeWidth;
  final Color fillColor;

  const _PantauTicketPainter({
    this.radius = 13,
    this.notchRadius = 11,
    this.strokeWidth = 1.3,
    this.fillColor = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final middle = h / 2;

    final path = Path()
      ..moveTo(radius, 0)
      ..lineTo(w - radius, 0)
      ..quadraticBezierTo(w, 0, w, radius)
      ..lineTo(w, middle - notchRadius)
      ..arcToPoint(
        Offset(w, middle + notchRadius),
        radius: Radius.circular(notchRadius),
        clockwise: false,
      )
      ..lineTo(w, h - radius)
      ..quadraticBezierTo(w, h, w - radius, h)
      ..lineTo(radius, h)
      ..quadraticBezierTo(0, h, 0, h - radius)
      ..lineTo(0, middle + notchRadius)
      ..arcToPoint(
        Offset(0, middle - notchRadius),
        radius: Radius.circular(notchRadius),
        clockwise: false,
      )
      ..lineTo(0, radius)
      ..quadraticBezierTo(0, 0, radius, 0)
      ..close();

    canvas.drawShadow(path, const Color(0x33000000), 2, false);

    canvas.drawPath(
      path,
      Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF333333)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }

  @override
  bool shouldRepaint(covariant _PantauTicketPainter old) {
    return old.radius != radius ||
        old.notchRadius != notchRadius ||
        old.strokeWidth != strokeWidth ||
        old.fillColor != fillColor;
  }
}
