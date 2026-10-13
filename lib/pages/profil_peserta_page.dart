
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Peserta {
  final String nama;
  final String kategori;
  final String tanggalLahir;
  final String jenisKelamin;
  final String namaOrangTua;
  final String nik;
  final String terakhirDiperiksa;
  final IconData avatar;
  final Color warnaAvatar;

  final List<double> berat;
  final List<double> tinggiBadan;
  final List<double> lingkarKepala;
  
// DATA PEMANTAUAN KESEHATAN LANSIA
final List<double> sistolik;
final List<double> diastolik;
final List<double> gulaDarah;
final List<double> denyutNadi;

  const Peserta({
    required this.nama,
    required this.kategori,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.namaOrangTua,
    required this.nik,
    required this.terakhirDiperiksa,
    required this.avatar,
    required this.warnaAvatar,
    required this.berat,
    required this.tinggiBadan,
    required this.lingkarKepala,
    this.sistolik = const [],
this.diastolik = const [],
this.gulaDarah = const [],
this.denyutNadi = const [],
  });
}

class ProfilPesertaPage extends StatefulWidget {
  final Peserta peserta;

  const ProfilPesertaPage({
    super.key,
    required this.peserta,
  });

  @override
  State<ProfilPesertaPage> createState() =>
      _ProfilPesertaPageState();
}

class _ProfilPesertaPageState extends State<ProfilPesertaPage> {
  int selectedGrafik = 0;
  bool get isLansia =>
    widget.peserta.kategori.toLowerCase().contains('lansia');

  // Periode grafik yang sedang dipilih
  int selectedPeriode = 3;

  List<String> get jenisGrafik => isLansia
    ? [
        'Tekanan Darah',
        'Berat Badan',
        'Gula Darah',
        'Denyut Nadi',
      ]
    : [
        'Berat',
        'Tinggi Badan',
        'Lingkar Kepala',
      ];


  // 1. Mengambil data sesuai tab yang dipilih
  List<double> getCurrentData() {
  final peserta = widget.peserta;

  if (isLansia) {
    switch (selectedGrafik) {
      case 0:
        return peserta.sistolik;
      case 1:
        return peserta.berat;
      case 2:
        return peserta.gulaDarah;
      case 3:
        return peserta.denyutNadi;
      default:
        return peserta.sistolik;
    }
  }

  switch (selectedGrafik) {
    case 0:
      return peserta.berat;
    case 1:
      return peserta.tinggiBadan;
    case 2:
      return peserta.lingkarKepala;
    default:
      return peserta.berat;
  }
}

  // 2. Menentukan satuan grafik
  String getCurrentUnit() {
  if (isLansia) {
    switch (selectedGrafik) {
      case 0:
        return 'mmHg';
      case 1:
        return 'kg';
      case 2:
        return 'mg/dL';
      case 3:
        return 'bpm';
      default:
        return '';
    }
  }

  return selectedGrafik == 0 ? 'kg' : 'cm';
}

Color getWarnaGrafik() {
  if (isLansia) {
    switch (selectedGrafik) {
      case 0:
        return const Color(0xFFE47788); // Tekanan darah
      case 1:
        return const Color(0xFF818DDC); // Berat
      case 2:
        return const Color(0xFF22B8A0); // Gula darah
      case 3:
        return const Color(0xFF9B55DA); // Nadi
    }
  }

  switch (selectedGrafik) {
    case 0:
      return const Color(0xFF818DDC);
    case 1:
      return const Color(0xFF22B8A0);
    case 2:
      return const Color(0xFFE78AAF);
    default:
      return const Color(0xFF818DDC);
  }
}

  // 3. Menentukan batas bawah grafik
 double getMinY(List<double> data) {
  switch (selectedGrafik) {
    case 0:
      return 5;
    case 1:
      return 65;
    case 2:
      return 40;
    default:
      return 0;
  }
}

double getMaxY(List<double> data) {
  switch (selectedGrafik) {
    case 0:
      return 13;
    case 1:
      return 105;
    case 2:
      return 52;
    default:
      return 100;
  }
}

double getInterval(List<double> data) {
  switch (selectedGrafik) {
    case 0:
      return 2;
    case 1:
      return 10;
    case 2:
      return 3;
    default:
      return 10;
  }
}

// TAMBAHKAN KODE GRAFIK TAB DI SINI


Widget grafikTab(String title, int index) {
  final aktif = selectedGrafik == index;

  final warnaTab = isLansia
      ? const [
          Color(0xFFE47788),
          Color(0xFF818DDC),
          Color(0xFF22B8A0),
          Color(0xFF9B55DA),
        ]
      : const [
          Color(0xFF818DDC),
          Color(0xFF22B8A0),
          Color(0xFFE78AAF),
        ];

  final warna = warnaTab[index];

  return GestureDetector(
    onTap: () {
      setState(() {
        selectedGrafik = index;
      });
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: aktif ? warna : Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: warna.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: aktif
              ? FontWeight.bold
              : FontWeight.w500,
          color: aktif ? Colors.white : warna,
        ),
      ),
    ),
  );
}


  
Widget tombolPeriode(String title, int bulan) {
  final aktif = selectedPeriode == bulan;

  return GestureDetector(
    onTap: () {
      setState(() {
        selectedPeriode = bulan;
      });
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: aktif
    ? getWarnaGrafik()
    : const Color(0xFFF6F1FB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: aktif
              ? FontWeight.bold
              : FontWeight.w500,
          color: aktif
              ? Colors.white
              : const Color(0xFF9187A5),
        ),
      ),
    ),
  );
}

  
  

Widget buildGrowthChart() {
  final semuaData = getCurrentData();
  final unit = getCurrentUnit();
  final warnaGrafik = getWarnaGrafik();

  final tekananDarah = isLansia && selectedGrafik == 0;

  const semuaBulan = [
    'Jan', 'Feb', 'Mar', 'Apr',
    'Mei', 'Jun', 'Jul', 'Agu',
    'Sep', 'Okt', 'Nov', 'Des',
  ];

  final jumlahBulan = selectedPeriode;
  final bulan = semuaBulan.sublist(0, jumlahBulan);

  final jumlahData = semuaData.length < jumlahBulan
      ? semuaData.length
      : jumlahBulan;

  final data = semuaData.take(jumlahData).toList();

  final diastolik = tekananDarah
      ? widget.peserta.diastolik
          .take(jumlahBulan)
          .toList()
      : <double>[];

  if (data.isEmpty) {
    return const SizedBox(
      height: 245,
      child: Center(
        child: Text('Belum ada data pemeriksaan'),
      ),
    );
  }

  // Rentang sumbu Y termasuk kedua nilai tekanan darah
  final nilaiSemua = <double>[
    ...data,
    if (tekananDarah) ...diastolik,
  ];

  final minimum = nilaiSemua.reduce(
    (a, b) => a < b ? a : b,
  );

  final maksimum = nilaiSemua.reduce(
    (a, b) => a > b ? a : b,
  );

  final selisih = maksimum - minimum;
  final jarak = selisih == 0 ? 2.0 : selisih * 0.2;

  final minY = (minimum - jarak).floorToDouble();
  final maxY = (maksimum + jarak).ceilToDouble();
  final interval = (maxY - minY) / 4;

  final garisGrafik = <LineChartBarData>[
    LineChartBarData(
      spots: List.generate(
        data.length,
        (i) => FlSpot(i.toDouble(), data[i]),
      ),
      isCurved: true,
      curveSmoothness: 0.2,
      preventCurveOverShooting: true,
      color: warnaGrafik,
      barWidth: 2.5,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 3.5,
            color: warnaGrafik,
            strokeWidth: 1.5,
            strokeColor: Colors.white,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: !tekananDarah,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            warnaGrafik.withValues(alpha: 0.18),
            warnaGrafik.withValues(alpha: 0.01),
          ],
        ),
      ),
    ),
  ];

  // Tambahkan garis diastolik khusus tekanan darah
  if (tekananDarah && diastolik.isNotEmpty) {
    const warnaDiastolik = Color(0xFFF2B36B);

    garisGrafik.add(
      LineChartBarData(
        spots: List.generate(
          diastolik.length,
          (i) => FlSpot(i.toDouble(), diastolik[i]),
        ),
        isCurved: true,
        curveSmoothness: 0.2,
        preventCurveOverShooting: true,
        color: warnaDiastolik,
        barWidth: 2.5,
        dotData: FlDotData(
          show: true,
          getDotPainter:
              (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: 3.5,
              color: warnaDiastolik,
              strokeWidth: 1.5,
              strokeColor: Colors.white,
            );
          },
        ),
        belowBarData: BarAreaData(show: false),
      ),
    );
  }

  return Column(
    children: [
      // Keterangan dua garis tekanan darah
      if (tekananDarah)
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: [
              const Icon(
                Icons.circle,
                size: 11,
                color: Color(0xFFE47788),
              ),
              const SizedBox(width: 5),
              const Text(
                'Sistolik',
                style: TextStyle(fontSize: 11),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.circle,
                size: 11,
                color: Color(0xFFF2B36B),
              ),
              const SizedBox(width: 5),
              const Text(
                'Diastolik',
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),

      SizedBox(
        height: 245,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: (jumlahBulan - 1).toDouble(),
            minY: minY,
            maxY: maxY,

            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: interval,
              getDrawingHorizontalLine: (value) {
                return const FlLine(
                  color: Color(0xFFEAE5F2),
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
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();

                    if (index < 0 ||
                        index >= bulan.length ||
                        value != index.toDouble()) {
                      return const SizedBox();
                    }

                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 8,
                      child: Text(
                        bulan[index],
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
                  reservedSize: tekananDarah ? 58 : 52,
                  interval: interval,
                  getTitlesWidget: (value, meta) {
                    if (value <= minY + 0.001 ||
                        value >= maxY - 0.001) {
                      return const SizedBox();
                    }

                    final nilai =
                        value.toStringAsFixed(1);

                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 5,
                      child: Text(
                        '$nilai $unit',
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
                getTooltipColor: (spot) =>
                    const Color(0xFF49376B),
                getTooltipItems: (spots) {
                  return spots.map((spot) {
                    final index = spot.x.toInt();

                    final namaGaris = tekananDarah
                        ? spot.barIndex == 0
                            ? 'Sistolik'
                            : 'Diastolik'
                        : jenisGrafik[selectedGrafik];

                    return LineTooltipItem(
                      '${bulan[index]}\n'
                      '$namaGaris: '
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

            lineBarsData: garisGrafik,
          ),
          duration: const Duration(milliseconds: 550),
          curve: Curves.easeInOutCubic,
        ),
      ),
    ],
  );
}



  @override
  Widget build(BuildContext context) {
    final peserta = widget.peserta;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Profil Peserta',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 35),

            // KARTU IDENTITAS PESERTA
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
  radius: 35,
  backgroundColor: peserta.warnaAvatar,
  backgroundImage: AssetImage(
    peserta.nama == 'Raka'
        ? 'assets/images/avatar_raka.png'
        : 'assets/images/avatar_sari.png',
  ),
),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              peserta.nama,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              peserta.kategori,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        infoRow('NIK', peserta.nik),
                        infoRow(
                          'Tanggal Lahir',
                          peserta.tanggalLahir,
                        ),
                        infoRow(
                          'Jenis Kelamin',
                          peserta.jenisKelamin,
                        ),
                        infoRow(
                          'Nama Orang Tua',
                          peserta.namaOrangTua,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // RIWAYAT PEMERIKSAAN
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Riwayat Pemeriksaan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Terakhir diperiksa',
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    peserta.terakhirDiperiksa,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // GRAFIK PERTUMBUHAN
            
Container(
  width: double.infinity,
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(
      color: const Color(0xFFD4DBF5),
    ),
    borderRadius: BorderRadius.circular(20),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // JUDUL
      Text(
  isLansia
      ? 'Grafik Pemantauan Kesehatan'
      : 'Grafik Pertumbuhan',
  style: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
),

      const SizedBox(height: 15),

      // PILIH JENIS PENGUKURAN
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
  jenisGrafik.length,
  (index) => grafikTab(
    jenisGrafik[index],
    index,
  ),
),
        ),
      ),

      const SizedBox(height: 18),

      // PILIH PERIODE
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            tombolPeriode('3 Bulan', 3),
            const SizedBox(width: 6),
            tombolPeriode('6 Bulan', 6),
            const SizedBox(width: 6),
            tombolPeriode('12 Bulan', 12),
          ],
        ),
      ),

      const SizedBox(height: 16),

      // GRAFIK ANIMASI
      AnimatedSwitcher(
        duration: const Duration(
          milliseconds: 450,
        ),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: SizedBox(
          key: ValueKey(
            '${selectedGrafik}_$selectedPeriode',
          ),
          child: buildGrowthChart(),
        ),
      ),

      const SizedBox(height: 12),

      // KETERANGAN
      const Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 14,
            color: Color(0xFF9148D8),
          ),
          SizedBox(width: 7),
          Expanded(
            child: Text(
              'Grafik berdasarkan data pemeriksaan peserta.',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF9187A5),
              ),
            ),
          ),
        ],
      ),
    ],
  ),
),
  ],
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// GRAFIK SEDERHANA TANPA PACKAGE TAMBAHAN
class GrafikPainter extends CustomPainter {
  final List<double> values;
  final int jenis;

  GrafikPainter({
    required this.values,
    required this.jenis,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFABB7FF)
      ..strokeWidth = 0.8;

    final linePaint = Paint()
      ..color = const Color(0xFF818DDC)
      ..strokeWidth = 1.5;

    final dotPaint = Paint()
      ..color = const Color(0xFF818DDC);

    const left = 30.0;
    const top = 10.0;
    final right = size.width - 8;
    final bottom = size.height - 28;

    for (int i = 0; i <= 3; i++) {
      final y = top + (bottom - top) * i / 3;
      canvas.drawLine(
        Offset(left, y),
        Offset(right, y),
        gridPaint,
      );
    }

    if (values.isEmpty) return;

    final minValue = values.reduce(
      (a, b) => a < b ? a : b,
    );
    final maxValue = values.reduce(
      (a, b) => a > b ? a : b,
    );
    final range = maxValue - minValue;

    final points = <Offset>[];

    for (int i = 0; i < values.length; i++) {
      final x = left +
          (right - left) *
              (values.length == 1
                  ? 0.5
                  : i / (values.length - 1));

      canvas.drawLine(
        Offset(x, top),
        Offset(x, bottom),
        gridPaint,
      );

      final normalized = range == 0
          ? 0.5
          : (values[i] - minValue) / range;

      final y = bottom -
          15 -
          normalized * (bottom - top - 30);

      points.add(Offset(x, y));

      final label = TextPainter(
        text: TextSpan(
          text: ['Jan', 'Feb', 'Mar', 'Apr', 'Mei'][
              i % 5],
          style: const TextStyle(
            color: Color(0xFF818DDC),
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      label.paint(
        canvas,
        Offset(x - label.width / 2, bottom + 8),
      );
    }

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(
        points[i],
        points[i + 1],
        linePaint,
      );
    }

    for (final point in points) {
      canvas.drawCircle(point, 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant GrafikPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.jenis != jenis;
  }
}
