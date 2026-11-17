
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/auth_service.dart';

import 'change_password_page.dart';
import 'notification_page.dart';
import 'edit_profile_page.dart';
import 'ai_assistant_page.dart';
import 'profil_peserta_page.dart';
import 'logout_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _navIndex = 2;

  // ===================== DATA PROFIL =====================

  String nama = '';
  String telepon = '';
  String email = '';
  String avatarProfil = 'assets/images/avatar_siti.png';

  bool loadingProfil = true;
  bool loadingPeserta = true;

  String? errorProfil;
  String? errorPeserta;

  List<Peserta> daftarPeserta = [];

  final Color pink = const Color(0xFFE0468F);
  final Color ungu = const Color(0xFF9449B8);

  // ===================== LOAD SEMUA DATA =====================

  @override
  void initState() {
    super.initState();
    muatDataProfil();
    muatPeserta();
  }

  // ===================== AMBIL PROFIL USER =====================

  Future<void> muatDataProfil() async {
    if (mounted) {
      setState(() {
        loadingProfil = true;
        errorProfil = null;
      });
    }

    try {
      final hasil = await AuthService().getMe();

      // GET /auth/me mengembalikan data user secara langsung.
      final user = hasil['user'] is Map
          ? Map<String, dynamic>.from(hasil['user'])
          : hasil;

      if (!mounted) return;

      setState(() {
        nama = (user['nama'] ??
                user['name'] ??
                user['namaLengkap'] ??
                '')
            .toString();

        telepon = (user['telepon'] ??
                user['noTelepon'] ??
                user['phone'] ??
                '')
            .toString();

        email = (user['email'] ?? '').toString();

        avatarProfil = (user['avatar'] ??
                'assets/images/avatar_siti.png')
            .toString();

        loadingProfil = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingProfil = false;
        errorProfil = e.toString();
      });
    }
  }

  // ===================== AMBIL PESERTA DARI BACKEND =====================

  Future<void> muatPeserta() async {
    if (mounted) {
      setState(() {
        loadingPeserta = true;
        errorPeserta = null;
      });
    }

    try {
      final response = await AuthService.client
          .get(
            Uri.parse(
              '${AuthService.baseUrl}/peserta/saya',
            ),
            headers: {
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      final responseData =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 ||
          responseData['success'] != true) {
        throw Exception(
          responseData['message'] ?? 'Gagal mengambil data peserta',
        );
      }

      final List<dynamic> data =
          responseData['data'] as List<dynamic>? ?? [];

      final pesertaBaru = data.map((item) {
        final peserta = Map<String, dynamic>.from(item);

        return Peserta(
          id: (peserta['id'] ?? '').toString(),
          nama: (peserta['nama'] ?? '-').toString(),

          kategori: ubahKategori(
            (peserta['kategori'] ?? '').toString(),
          ),

          tanggalLahir: formatTanggal(
            peserta['tanggalLahir'],
          ),

          jenisKelamin: ubahJenisKelamin(
            (peserta['jenisKelamin'] ?? '').toString(),
          ),

          namaOrangTua: (
            peserta['namaWali'] ??
            peserta['namaOrangTua'] ??
            '-'
          ).toString(),

          nik: (peserta['nik'] ?? '-').toString(),

          terakhirDiperiksa: '-',

          avatar: iconPeserta(
            (peserta['kategori'] ?? '').toString(),
          ),

          warnaAvatar: warnaPeserta(
            (peserta['kategori'] ?? '').toString(),
          ),

          // Grafik akan diisi dari data pemeriksaan.
          berat: const [],
          tinggiBadan: const [],
          lingkarKepala: const [],

          sistolik: const [],
          diastolik: const [],
          gulaDarah: const [],
          denyutNadi: const [],
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        daftarPeserta = pesertaBaru;
        loadingPeserta = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingPeserta = false;
        errorPeserta = e.toString();
      });
    }
  }

  // ===================== FORMAT KATEGORI =====================

  String ubahKategori(String kategori) {
    switch (kategori.toUpperCase()) {
      case 'BALITA':
        return 'Balita';

      case 'IBU_HAMIL':
        return 'Ibu Hamil';

      case 'LANSIA':
        return 'Lansia';

      default:
        return kategori;
    }
  }

  // ===================== FORMAT JENIS KELAMIN =====================

  String ubahJenisKelamin(String jenisKelamin) {
    switch (jenisKelamin.toUpperCase()) {
      case 'LAKI_LAKI':
        return 'Laki-Laki';

      case 'PEREMPUAN':
        return 'Perempuan';

      default:
        return jenisKelamin;
    }
  }

  // ===================== FORMAT TANGGAL =====================

  String formatTanggal(dynamic tanggal) {
    if (tanggal == null) return '-';

    try {
      final date = DateTime.parse(tanggal.toString());

      final hari = date.day.toString().padLeft(2, '0');
      final bulan = date.month.toString().padLeft(2, '0');

      return '$hari-$bulan-${date.year}';
    } catch (_) {
      return tanggal.toString();
    }
  }

  // ===================== ICON PESERTA =====================

  IconData iconPeserta(String kategori) {
    switch (kategori.toUpperCase()) {
      case 'BALITA':
        return Icons.child_care;

      case 'IBU_HAMIL':
        return Icons.pregnant_woman;

      case 'LANSIA':
        return Icons.elderly;

      default:
        return Icons.person;
    }
  }

  // ===================== WARNA PESERTA =====================

  Color warnaPeserta(String kategori) {
    switch (kategori.toUpperCase()) {
      case 'BALITA':
        return const Color(0xFFFFD5C2);

      case 'IBU_HAMIL':
        return const Color(0xFFE9D5FF);

      case 'LANSIA':
        return const Color(0xFFE8B8AD);

      default:
        return const Color(0xFFDCC6F0);
    }
  }

  // ===================== EDIT PROFIL =====================

  Future<void> bukaEditProfil() async {
    final hasil = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          nama: nama,
          telepon: telepon,
          email: email,
          avatar: avatarProfil,
        ),
      ),
    );

    if (!mounted) return;

    // Ambil ulang data dari database agar selalu sinkron.
    await muatDataProfil();

    if (!mounted) return;

    if (hasil != null) {
      tampilPesan('Profil berhasil diperbarui');
    }
  }

  // ===================== NOTIFIKASI =====================

  void bukaNotifikasi() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationPage(),
      ),
    );
  }

  // ===================== UBAH PASSWORD =====================

  void ubahPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePasswordPage(),
      ),
    );
  }

  // ===================== PESAN =====================

  void tampilPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  // ===================== KARTU PESERTA =====================

  Widget buildPesertaSaya() {
    if (loadingPeserta) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 25),
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF9148D8),
          ),
        ),
      );
    }

    if (errorPeserta != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3F3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 28,
            ),
            const SizedBox(height: 8),
            const Text(
              'Gagal memuat peserta',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              errorPeserta!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            ),
            TextButton(
              onPressed: muatPeserta,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (daftarPeserta.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: const Column(
          children: [
            Icon(
              Icons.people_outline,
              size: 42,
              color: Color(0xFFB9A5D0),
            ),
            SizedBox(height: 8),
            Text(
              'Belum ada peserta terdaftar',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: daftarPeserta.map((peserta) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfilPesertaPage(peserta: peserta),
                  ),
                );
              },
              child: Container(
                width: 91,
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black87,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: peserta.warnaAvatar,
                      child: Icon(
                        peserta.avatar,
                        size: 29,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      peserta.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      peserta.kategori,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ===================== MENU PENGATURAN =====================

  Widget menuPengaturan(
    IconData ikon,
    String judul,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black87),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                Icon(ikon, size: 21),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    judul,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===================== BOTTOM NAVIGATION =====================

  void _onNavTap(int index) {
    if (index == 0) {
      setState(() {
        _navIndex = 0;
      });

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dashboard',
        (route) => false,
      );

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
            _navIndex = 2;
          });
        }
      });

      return;
    }

    if (index == 2) {
      setState(() {
        _navIndex = 2;
      });
    }
  }

  Widget _buildBottomNav() {
    return SizedBox(
      height: 78,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 10,
            bottom: 0,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
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
                      const SizedBox(width: 76),
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

          // TOMBOL AI LITA
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
                    ? Icon(
                        itemIcon,
                        size: 26,
                        color: Colors.white,
                      )
                    : ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) =>
                            const LinearGradient(
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
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: selected
                      ? const Color(0xFF9148D8)
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== TAMPILAN PROFIL =====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: const Color(0xFF9148D8),
                  onRefresh: () async {
                    await Future.wait([
                      muatDataProfil(),
                      muatPeserta(),
                    ]);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // HEADER PROFIL

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(
                            18,
                            38,
                            18,
                            30,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [ungu, pink],
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Profil Saya',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 23),

                              // KARTU DATA USER

                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(17),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 37,
                                      backgroundColor:
                                          const Color(0xFFFFD1AE),
                                      backgroundImage:
                                          avatarProfil.startsWith('http')
                                              ? NetworkImage(avatarProfil)
                                              : AssetImage(avatarProfil)
                                                  as ImageProvider,
                                    ),
                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: loadingProfil
                                          ? const Padding(
                                              padding: EdgeInsets.all(10),
                                              child: LinearProgressIndicator(
                                                color: Color(0xFF9148D8),
                                              ),
                                            )
                                          : errorProfil != null
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Gagal memuat profil',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: muatDataProfil,
                                                      child: const Text(
                                                        'Coba Lagi',
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      nama.isEmpty
                                                          ? 'Pengguna PELITA'
                                                          : nama,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 7),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.phone_outlined,
                                                          size: 14,
                                                        ),
                                                        const SizedBox(width: 3),
                                                        Expanded(
                                                          child: Text(
                                                            telepon.isEmpty
                                                                ? '-'
                                                                : telepon,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.mail_outline,
                                                          size: 14,
                                                        ),
                                                        const SizedBox(width: 3),
                                                        Expanded(
                                                          child: Text(
                                                            email.isEmpty
                                                                ? '-'
                                                                : email,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 11,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                    ),

                                    IconButton(
                                      onPressed: loadingProfil
                                          ? null
                                          : bukaEditProfil,
                                      icon: const Icon(Icons.edit_square),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ISI PROFIL

                        Transform.translate(
                          offset: const Offset(0, -12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Peserta Saya',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                buildPesertaSaya(),

                                const SizedBox(height: 30),

                                const Text(
                                  'Pengaturan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                menuPengaturan(
                                  Icons.password,
                                  'Ubah Kata Sandi',
                                  ubahPassword,
                                ),

                                menuPengaturan(
                                  Icons.notifications_none,
                                  'Notifikasi',
                                  bukaNotifikasi,
                                ),

                                menuPengaturan(
                                  Icons.smart_toy_outlined,
                                  'Tentang Posyandu',
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AiAssistantPage(),
                                      ),
                                    );
                                  },
                                ),

                                menuPengaturan(
                                  Icons.logout,
                                  'Logout',
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LogoutPage(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // NAVBAR

              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }
}
