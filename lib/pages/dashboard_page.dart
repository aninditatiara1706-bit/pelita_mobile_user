
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import halaman profile, tentang, dan layanan
import 'profile_page.dart';
import 'tentang_page.dart';
import 'layanan_balita.dart';
import 'layanan_ibu_hamil.dart';
import 'layanan_lansia.dart';
import 'riwayat_pelayanan_page.dart';
import 'pantau_antrean_page.dart';

/// Warna utama aplikasi PELITA
class PelitaColors {
  static const purple = Color(0xFF8A3FC7);
  static const pink = Color(0xFFE5507E);
  static const navy = Color(0xFF1A1A5E);
  static const chart = Color(0xFF7C7FD8);
  static const chipPurple = Color(0xFF8A3FC7);
  static const bg = Color(0xFFF7F4FB);

  // Gradasi background navbar
  static const navPurple = Color(0xFFE8D9FA);
  static const navPink = Color(0xFFFFDDE8);
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedChip = 0;
  int _navIndex = 0;

  // Folder penyimpanan gambar
  static const String _assetPath = 'assets/images';

  final List<String> _chips = [
    'Berat Badan',
    'Tinggi Badan',
    'Lingkar Kepala',
  ];

  // Daftar menu dan halaman tujuan
  final List<_MenuItem> _menus = const [
    _MenuItem(
      'Balita',
      'icon_balita.png',
      targetPage: LayananBalitaPage(),
    ),
    _MenuItem(
      'Ibu Hamil',
      'icon_ibu_hamil.png',
      targetPage: LayananIbuHamilPage(),
    ),
    _MenuItem(
      'Lansia',
      'icon_lansia.png',
      targetPage: LayananLansiaPage(),
    ),
    _MenuItem('Booking\nAntrean', 'icon_booking.png'),
    _MenuItem(
      'Antrean', 
      'icon_antrean.png',
      targetPage: RiwayatPelayananPage(), 
    ),
    _MenuItem(
      'Riwayat',
      'icon_riwayat.png',
      targetPage: RiwayatPelayananPage(),
    ),
  ];

  // Data grafik pertumbuhan Januari - Mei
  final Map<int, _ChartData> _chartData = const {
    0: _ChartData(
      minY: 6,
      maxY: 12,
      step: 2,
      unit: 'kg',
      values: [7.3, 8.5, 9.2, 10.0, 11.0],
    ),
    1: _ChartData(
      minY: 60,
      maxY: 80,
      step: 5,
      unit: 'cm',
      values: [65, 67.5, 70, 72, 74],
    ),
    2: _ChartData(
      minY: 38,
      maxY: 46,
      step: 2,
      unit: 'cm',
      values: [40, 41, 42.5, 43.5, 44.5],
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildHeader(),
                  _buildGrowthChartCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  // =========================================================
  // HEADER DAN MENU
  // =========================================================

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 230,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                PelitaColors.purple,
                PelitaColors.pink,
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/images/logo_pelita.png',
                              width: 34,
                              height: 34,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 34,
                                  height: 34,
                                  alignment: Alignment.center,
                                  color: Colors.white.withOpacity(0.25),
                                  child: const Icon(
                                    Icons.image_not_supported_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'PELITA',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      _buildBell(),
                    ],
                  ),
                  const SizedBox(height: 34),
                  Text(
                    'Hallo, Siti Nurhaliza',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Kesehatan Keluarga, lebih mudah bersama PELITA',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Kartu menu
        Padding(
          padding: const EdgeInsets.only(
            top: 140,
            left: 12,
            right: 12,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _menus.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 4,
                mainAxisExtent: 98,
              ),
              itemBuilder: (context, i) {
                return _buildMenuItem(_menus[i]);
              },
            ),
          ),
        ),

        // Ruang untuk kartu menu
        const SizedBox(
          height: 410,
          width: double.infinity,
        ),
      ],
    );
  }

  // =========================================================
  // IKON NOTIFIKASI
  // =========================================================

  Widget _buildBell() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(
          Icons.notifications_none_rounded,
          color: Colors.white,
          size: 32,
        ),
        Positioned(
          right: -2,
          top: -4,
          child: Container(
            width: 17,
            height: 17,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFE53935),
              shape: BoxShape.circle,
            ),
            child: Text(
              '2',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // ITEM MENU
  // =========================================================

  Widget _buildMenuItem(_MenuItem item) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      splashColor: PelitaColors.purple.withOpacity(0.15),
      highlightColor: PelitaColors.pink.withOpacity(0.08),
      onTap: () {
        if (item.targetPage != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => item.targetPage!,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Menu ${item.label.replaceAll('\n', ' ')} '
                'segera hadir!',
              ),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 62,
            height: 62,
            color: Colors.white,
            child: Image.asset(
              '$_assetPath/${item.image}',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.grey,
                  size: 30,
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              height: 1.25,
              color: const Color(0xFF222222),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // GRAFIK PERTUMBUHAN
  // =========================================================

  Widget _buildGrowthChartCard() {
    final data = _chartData[_selectedChip]!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE3DFF0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Grafik Pertumbuhan',
            style: GoogleFonts.poppins(
              color: PelitaColors.navy,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),

          // Pilihan kategori grafik
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_chips.length, (i) {
                final selected = i == _selectedChip;

                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedChip = i;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? PelitaColors.chipPurple
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? PelitaColors.chipPurple
                              : const Color(0xFFCFCFD8),
                        ),
                      ),
                      child: Text(
                        _chips[i],
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF555555),
                          fontWeight: selected
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 150,
            width: double.infinity,
            child: CustomPaint(
              painter: _LineChartPainter(
                data: data,
                labels: const [
                  'Jan',
                  'Feb',
                  'Mar',
                  'Apr',
                  'Mei',
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // BOTTOM NAVIGATION
  // =========================================================

  void _onNavTap(int index) {
    if (index == 0) {
      setState(() {
        _navIndex = 0;
      });
      return;
    }

    if (index == 1) {
      setState(() {
        _navIndex = 1;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const TentangPage(),
        ),
      ).then((_) {
        if (mounted) {
          setState(() {
            _navIndex = 0;
          });
        }
      });

      return;
    }

    if (index == 2) {
      setState(() {
        _navIndex = index;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ProfilePage(),
        ),
      ).then((_) {
        if (mounted) {
          setState(() {
            _navIndex = 0;
          });
        }
      });

      return;
    }
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE05297),
            Color(0xFF7E3FB4),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _navIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
          onTap: _onNavTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'Tentang',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
} // Penutup class _DashboardPageState

// =============================================================
// MODEL MENU
// =============================================================

class _MenuItem {
  final String label;
  final String image;
  final Widget? targetPage;

  const _MenuItem(
    this.label,
    this.image, {
    this.targetPage,
  });
}

// =============================================================
// MODEL GRAFIK
// =============================================================

class _ChartData {
  final double minY;
  final double maxY;
  final double step;
  final String unit;
  final List<double> values;

  const _ChartData({
    required this.minY,
    required this.maxY,
    required this.step,
    required this.unit,
    required this.values,
  });
}

// =============================================================
// CUSTOM PAINTER GRAFIK
// =============================================================

class _LineChartPainter extends CustomPainter {
  final _ChartData data;
  final List<String> labels;

  _LineChartPainter({
    required this.data,
    required this.labels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 34.0;
    const rightPad = 10.0;
    const topPad = 8.0;
    const bottomPad = 22.0;

    final chartW = size.width - leftPad - rightPad;
    final chartH = size.height - topPad - bottomPad;

    final gridPaint = Paint()
      ..color = const Color(0xFF8E94DD)
      ..strokeWidth = 0.8;

    final textStyle = GoogleFonts.poppins(
      fontSize: 8,
      color: const Color(0xFF555555),
    );

    double yFor(double v) {
      return topPad +
          chartH -
          ((v - data.minY) / (data.maxY - data.minY)) * chartH;
    }

    // Garis horizontal dan label sumbu Y
    for (
      double v = data.minY;
      v <= data.maxY + 0.001;
      v += data.step
    ) {
      final y = yFor(v);

      canvas.drawLine(
        Offset(leftPad, y),
        Offset(size.width - rightPad, y),
        gridPaint,
      );

      _drawText(
        canvas,
        '${v.toInt()} ${data.unit}',
        Offset(0, y - 5),
        textStyle,
      );
    }

    // Garis vertikal dan label sumbu X
    final n = data.values.length;
    const xInset = 8.0;
    final usableW = chartW - xInset * 2;
    final stepX = n > 1 ? usableW / (n - 1) : usableW;

    for (int i = 0; i < n; i++) {
      final x = leftPad + xInset + stepX * i;

      canvas.drawLine(
        Offset(x, topPad),
        Offset(x, topPad + chartH),
        Paint()
          ..color = const Color(0xFF8E94DD)
          ..strokeWidth = 0.6,
      );

      _drawText(
        canvas,
        labels[i],
        Offset(x - 6, topPad + chartH + 5),
        textStyle.copyWith(
          fontWeight: FontWeight.w600,
        ),
      );
    }

    // Garis data grafik
    final linePaint = Paint()
      ..color = PelitaColors.chart
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < n; i++) {
      final p = Offset(
        leftPad + xInset + stepX * i,
        yFor(data.values[i]),
      );

      points.add(p);

      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }

    canvas.drawPath(path, linePaint);

    // Titik data grafik
    final dotPaint = Paint()
      ..color = PelitaColors.chart;

    for (final p in points) {
      canvas.drawCircle(p, 3.2, dotPaint);
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    TextStyle style,
  ) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) {
    return old.data != data || old.labels != labels;
  }
}
