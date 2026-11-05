import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_page.dart';
import 'ai_assistant_page.dart';
import 'notification_page.dart';
import 'layanan_balita.dart';
import 'layanan_ibu_hamil.dart';
import 'layanan_lansia.dart';
import 'riwayat_pelayanan_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'daftar_posyandu_page.dart';
import 'pantau_antrean_page.dart';

class PelitaColors {
  static const purple = Color(0xFF8A3FC7);
  static const pink = Color(0xFFE5507E);
  static const navy = Color(0xFF1A1A5E);
  static const chart = Color(0xFF7C7FD8);
  static const chipPurple = Color(0xFF8A3FC7);
  static const bg = Color(0xFFF7F4FB);
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

  static const String _assetPath = 'assets/images';

  final List<_MenuItem> _menus = const [
    _MenuItem(
      'Balita',
      'icon_balita_dashboard.png',
      targetPage: LayananBalitaPage(),
    ),
    _MenuItem(
      'Ibu Hamil',
      'icon_ibuhamil_dashboard.png',
      targetPage: LayananIbuHamilPage(),
    ),
    _MenuItem(
      'Lansia',
      'icon_lansia_dashboard.png',
      targetPage: LayananLansiaPage(),
    ),
    _MenuItem(
  'Booking\nAntrean',
  'icon_booking.png',
  targetPage: DaftarPosyanduPage(),
),
_MenuItem(
  'Antrean',
  'icon_antrean_dashboard.png',
  targetPage: PantauAntreanPage(
    nomorAntrean: 'A-12',
    namaPeserta: 'Raka',
  ),
),
    _MenuItem(
      'Riwayat',
      'icon_riwayat_dashboard.png',
      targetPage: RiwayatPelayananPage(),
    ),
  ];

  List<GrowthRecord> _riwayatPertumbuhan = [];
  DateTime? _tanggalDaftarTerakhir;

  static const List<String> _namaBulan = [
    'Jan', 'Feb', 'Mar', 'Apr',
    'Mei', 'Jun', 'Jul', 'Agu',
    'Sep', 'Okt', 'Nov', 'Des',
  ];

  @override
  void initState() {
    super.initState();
    _muatGrafik();
  }

  
  Future<void> _muatGrafik() async {
    final sekarang = DateTime.now();

    final contoh = <GrowthRecord>[
      GrowthRecord(
        tanggal: DateTime(sekarang.year, sekarang.month - 4, 1),
        berat: 7.3,
        tinggi: 65,
        lingkarKepala: 40,
      ),
      GrowthRecord(
        tanggal: DateTime(sekarang.year, sekarang.month - 3, 1),
        berat: 8.5,
        tinggi: 67.5,
        lingkarKepala: 41,
      ),
      GrowthRecord(
        tanggal: DateTime(sekarang.year, sekarang.month - 2, 1),
        berat: 9.2,
        tinggi: 70,
        lingkarKepala: 42.5,
      ),
      GrowthRecord(
        tanggal: DateTime(sekarang.year, sekarang.month - 1, 1),
        berat: 10.0,
        tinggi: 72,
        lingkarKepala: 43.5,
      ),
      GrowthRecord(
        tanggal: DateTime(sekarang.year, sekarang.month, 1),
        berat: 11.0,
        tinggi: 74,
        lingkarKepala: 44.5,
      ),
    ];

    if (!mounted) return;

    setState(() {
      _riwayatPertumbuhan = contoh;
      _tanggalDaftarTerakhir = sekarang;
    });
  }


  bool get _tampilkanGrafik {
    return _tanggalDaftarTerakhir != null &&
        DateUtils.isSameDay(
          _tanggalDaftarTerakhir,
          DateTime.now(),
        ) &&
        _riwayatPertumbuhan.isNotEmpty;
  }

  


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

  const SizedBox(height: 12),

  if (_tampilkanGrafik)
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
                                  color: Colors.white.withValues(alpha: 0.25),
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
    top: 185,
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
                  color: Colors.black.withValues(alpha: 0.18),
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

const SizedBox(
  height: 455,
  width: double.infinity,
),
      ],
    );
  }

  // =========================================================
  // IKON NOTIFIKASI
  // =========================================================

  
Widget _buildBell() {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NotificationPage(),
        ),
      );
    },
    child: Stack(
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
    ),
  );
}


  // =========================================================
  // ITEM MENU
  // =========================================================

  Widget _buildMenuItem(_MenuItem item) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      splashColor: PelitaColors.purple.withValues(alpha: 0.15),
      highlightColor: PelitaColors.pink.withValues(alpha: 0.08),
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
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final kecepatan = details.primaryVelocity ?? 0;

        if (kecepatan.abs() < 100) return;

        setState(() {
          if (kecepatan < 0 && _selectedChip < 2) {
            _selectedChip++;
          } else if (kecepatan > 0 && _selectedChip > 0) {
            _selectedChip--;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE3DFF0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
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
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A5E),
              ),
            ),

            const SizedBox(height: 12),

            // Hanya tiga tombol jenis grafik
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildGrafikTab('Berat Badan', 0),
                  _buildGrafikTab('Tinggi Badan', 1),
                  _buildGrafikTab('Lingkar Kepala', 2),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Grafik bergaya Profil Peserta
            _buildGrafikGaris(),
          ],
        ),
      ),
    );
  }

  Widget _buildGrafikTab(String title, int index) {
    final aktif = _selectedChip == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedChip = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: aktif
              ? const Color(0xFF9148D8)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: aktif
                ? const Color(0xFF9148D8)
                : const Color(0xFFC9D2F8),
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: aktif
                ? Colors.white
                : const Color(0xFF818DDC),
          ),
        ),
      ),
    );
  }

  Widget _buildGrafikGaris() {
    final sekarang = DateTime.now();

    final bulan = List.generate(
      5,
      (index) => DateTime(
        sekarang.year,
        sekarang.month - 4 + index,
        1,
      ),
    );

    final labels = bulan
        .map((item) => _namaBulan[item.month - 1])
        .toList();

    final unit = _selectedChip == 0 ? 'kg' : 'cm';

    final titik = <FlSpot>[];

    for (int i = 0; i < bulan.length; i++) {
      final dataBulan = _riwayatPertumbuhan.where(
        (item) =>
            item.tanggal.year == bulan[i].year &&
            item.tanggal.month == bulan[i].month,
      ).toList();

      if (dataBulan.isEmpty) continue;

      final item = dataBulan.last;

      final nilai = _selectedChip == 0
          ? item.berat
          : _selectedChip == 1
              ? item.tinggi
              : item.lingkarKepala;

      titik.add(FlSpot(i.toDouble(), nilai));
    }

    if (titik.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text('Belum ada data pemeriksaan'),
        ),
      );
    }

    final nilaiY = titik.map((e) => e.y).toList();

    final terendah = nilaiY.reduce(
      (a, b) => a < b ? a : b,
    );

    final tertinggi = nilaiY.reduce(
      (a, b) => a > b ? a : b,
    );

    final selisih = tertinggi - terendah;
    final jarak = selisih == 0 ? 2.0 : selisih * 0.3;

    final minY = (terendah - jarak).floorToDouble();
    final maxY = (tertinggi + jarak).ceilToDouble();

    final interval = (maxY - minY) / 4;

    const warnaGrafik = Color(0xFF9148D8);

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 4,
          minY: minY,
          maxY: maxY,

          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: interval,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: const Color(0xFFEBE6F3),
                strokeWidth: 0.8,
              );
            },
          ),

          borderData: FlBorderData(show: false),

          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),

            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();

                  if (index < 0 ||
                      index >= labels.length ||
                      value != index.toDouble()) {
                    return const SizedBox();
                  }

                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8,
                    child: Text(
                      labels[index],
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9187A5),
                      ),
                    ),
                  );
                },
              ),
            ),

            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                interval: interval,
                getTitlesWidget: (value, meta) {
                  if (value <= minY + 0.001 ||
                      value >= maxY - 0.001) {
                    return const SizedBox();
                  }

                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 4,
                    child: Text(
                      '${value.toStringAsFixed(1)} $unit',
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF9187A5),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) =>
    const Color(0xFF6631A0),
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  final index = spot.x.round();

                  return LineTooltipItem(
                    '${labels[index]}\n'
                    '${spot.y.toStringAsFixed(1)} $unit',
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),

          lineBarsData: [
            LineChartBarData(
              spots: titik,
              isCurved: true,
              curveSmoothness: 0.22,
              preventCurveOverShooting: true,
              color: warnaGrafik,
              barWidth: 2.5,
              isStrokeCapRound: true,

              dotData: FlDotData(
                show: true,
                getDotPainter: (
                  spot,
                  percent,
                  barData,
                  index,
                ) {
                  return FlDotCirclePainter(
                    radius: 3.5,
                    color: warnaGrafik,
                    strokeWidth: 1.5,
                    strokeColor: Colors.white,
                  );
                },
              ),

              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    warnaGrafik.withValues(alpha: 0.18),
                    warnaGrafik.withValues(alpha: 0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
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
          builder: (_) => const AiAssistantPage(),
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
    return SizedBox(
      height: 78,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // BACKGROUND NAVBAR
          Positioned(
            left: 0,
            right: 0,
            top: 10,
            bottom: 0,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // GARIS NAVBAR KIRI DAN KANAN AI
Row(
  children: [
    // GARIS SEBELAH KIRI
    Expanded(
      child: Container(
        height: 1.2,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE0468F),
              Color(0xFFC94AB5),
            ],
          ),
        ),
      ),
    ),

    // JARAK UNTUK LINGKARAN AI
    const SizedBox(width: 76),

    // GARIS SEBELAH KANAN
    Expanded(
      child: Container(
        height: 1.2,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFC94AB5),
              Color(0xFF9148D8),
            ],
          ),
        ),
      ),
    ),
  ],
),

                  Expanded(
                    child: Row(
                      children: [
                        _buildBottomNavItem(
                          index: 0,
                          label: 'Home',
                        ),

                        const SizedBox(width: 82),

                        _buildBottomNavItem(
                          index: 2,
                          label: 'Profile',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // TOMBOL AI LITA DI TENGAH
          Positioned(
            top: -18,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => _onNavTap(1),
                child: Container(
                  width: 76,
                  height: 76,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF9148D8),
                      width: 1.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9148D8)
                            .withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
  'assets/images/icon_lita_navbar.png',
  width: 64,
  height: 64,
  fit: BoxFit.contain,
  errorBuilder: (context, error, stackTrace) {
    return const Icon(
      Icons.smart_toy_rounded,
      color: Color(0xFF9148D8),
      size: 42,
    );
  },
),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ITEM HOME DAN PROFILE
  Widget _buildBottomNavItem({
    required int index,
    required String label,
  }) {
    final selected = _navIndex == index;
    final homeAktif = index == 0 && selected;
    final profileAktif = index == 2 && selected;
    final itemAktif = homeAktif || profileAktif;
    final itemIcon = homeAktif
        ? Icons.home_rounded
        : profileAktif
            ? Icons.person_rounded
            : index == 0
                ? Icons.home_outlined
                : Icons.person_outline_rounded;

    return Expanded(
      child: InkWell(
        onTap: () => _onNavTap(index),
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: itemAktif
                      ? const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xC7E0468F),
                            Color(0xC79148D8),
                          ],
                        )
                      : null,
                ),
                child: itemAktif
                    ? Icon(itemIcon, size: 26, color: Colors.white)
                    : ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFFE0468F),
                            Color(0xFF9148D8),
                          ],
                        ).createShader(bounds),
                        child: Icon(
                          itemIcon,
                          size: 26,
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(height: 1),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
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

class GrowthRecord {

  final DateTime tanggal;
  final double berat;
  final double tinggi;
  final double lingkarKepala;

  const GrowthRecord({
    required this.tanggal,
    required this.berat,
    required this.tinggi,
    required this.lingkarKepala,
  });

  Map<String, dynamic> toJson() => {
        'tanggal': tanggal.toIso8601String(),
        'berat': berat,
        'tinggi': tinggi,
        'lingkarKepala': lingkarKepala,
      };

  factory GrowthRecord.fromJson(Map<String, dynamic> json) {
    return GrowthRecord(
      tanggal: DateTime.parse(json['tanggal'] as String),
      berat: (json['berat'] as num).toDouble(),
      tinggi: (json['tinggi'] as num).toDouble(),
      lingkarKepala: (json['lingkarKepala'] as num).toDouble(),
    );
  }
}

class DashboardGrowthResult {
  final DateTime? tanggalDaftar;
  final List<GrowthRecord> riwayat;

  const DashboardGrowthResult({
    required this.tanggalDaftar,
    required this.riwayat,
  });
}

class DashboardGrowthStore {
  static const _pesertaAktifKey =
      'pelita_dashboard_peserta_aktif';

  static const _tanggalDaftarKey =
      'pelita_dashboard_tanggal_daftar';

  static String _keyRiwayat(String pesertaId) =>
      'pelita_dashboard_riwayat_$pesertaId';

  static Future<void> simpan({
    required String pesertaId,
    required double berat,
    required double tinggi,
    required double lingkarKepala,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final sekarang = DateTime.now();

    final key = _keyRiwayat(pesertaId);
    final riwayat = _baca(prefs.getString(key));

    riwayat.removeWhere(
      (item) =>
          item.tanggal.year == sekarang.year &&
          item.tanggal.month == sekarang.month,
    );

    riwayat.add(
      GrowthRecord(
        tanggal: sekarang,
        berat: berat,
        tinggi: tinggi,
        lingkarKepala: lingkarKepala,
      ),
    );

    riwayat.sort(
      (a, b) => a.tanggal.compareTo(b.tanggal),
    );

    await prefs.setString(
      key,
      jsonEncode(riwayat.map((e) => e.toJson()).toList()),
    );

    await prefs.setString(
      _pesertaAktifKey,
      pesertaId,
    );

    await prefs.setString(
      _tanggalDaftarKey,
      sekarang.toIso8601String(),
    );
  }

  static Future<DashboardGrowthResult> ambil() async {
    final prefs = await SharedPreferences.getInstance();

    final pesertaId = prefs.getString(_pesertaAktifKey);
    final tanggalText = prefs.getString(_tanggalDaftarKey);

    if (pesertaId == null || tanggalText == null) {
      return const DashboardGrowthResult(
        tanggalDaftar: null,
        riwayat: [],
      );
    }

    final riwayat = _baca(
      prefs.getString(_keyRiwayat(pesertaId)),
    );

    riwayat.sort(
      (a, b) => a.tanggal.compareTo(b.tanggal),
    );

    return DashboardGrowthResult(
      tanggalDaftar: DateTime.parse(tanggalText),
      riwayat: riwayat.reversed
          .take(5)
          .toList()
          .reversed
          .toList(),
    );
  }

  static List<GrowthRecord> _baca(String? data) {
    if (data == null || data.isEmpty) return [];

    final list = jsonDecode(data) as List<dynamic>;

    return list
        .map(
          (item) => GrowthRecord.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }
}
