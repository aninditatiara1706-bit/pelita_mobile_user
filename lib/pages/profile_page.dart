
import 'package:flutter/material.dart';
import 'change_password_page.dart';
import 'notification_page.dart';
import 'edit_profile_page.dart';
import 'ai_assistant_page.dart';
import 'profil_peserta_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

final List<Peserta> daftarPeserta = [
  const Peserta(
    nama: 'Raka',
    kategori: 'Balita 3 Tahun',
    tanggalLahir: '12-09-2022',
    jenisKelamin: 'Laki-Laki',
    namaOrangTua: 'Siti Nurhaliza',
    nik: 'XXXXXXXXXX',
    terakhirDiperiksa: '12 Mei 2026',
    avatar: Icons.child_care,
    warnaAvatar: Color(0xFFFFD5C2),
    
berat: [
  7.2, 8.1, 7.8, 9.4, 9.1, 9.8,
  9.5, 10.2, 10.0, 10.8, 10.5, 11.2,
],

tinggiBadan: [
  72, 77, 76, 83, 86, 85,
  89, 91, 90, 94, 96, 98,
],

lingkarKepala: [
  44.0, 45.2, 44.8, 46.0, 45.7, 46.5,
  46.2, 47.0, 46.8, 47.5, 47.2, 48.0,
],

  ),
  const Peserta(
    nama: 'Sari',
    kategori: 'Lansia 67 Tahun',
    tanggalLahir: '15-04-1959',
    jenisKelamin: 'Perempuan',
    namaOrangTua: '-',
    nik: 'XXXXXXXXXX',
    terakhirDiperiksa: '10 Mei 2026',
    avatar: Icons.face_3,
    warnaAvatar: Color(0xFFE8B8AD),
    
berat: [
  58, 59, 58.5, 60, 59, 60.5,
  59.5, 61, 60, 60.8, 59.8, 60.5,
],

tinggiBadan: [
  158, 158, 158, 158, 158, 158,
  158, 158, 158, 158, 158, 158,
],

lingkarKepala: [
  56, 56, 56, 56, 56, 56,
  56, 56, 56, 56, 56, 56,
],

sistolik: [
  138, 142, 135, 145, 140, 136,
  144, 139, 133, 141, 137, 134,
],

diastolik: [
  88, 90, 85, 92, 87, 84,
  91, 86, 82, 89, 85, 83,
],

gulaDarah: [
  145, 153, 140, 158, 148, 136,
  155, 143, 139, 151, 142, 137,
],

denyutNadi: [
  78, 84, 76, 82, 80, 74,
  86, 79, 77, 83, 75, 78,
],

  ),
];

class _ProfilePageState extends State<ProfilePage> {
  String nama = 'Siti Nurhaliza';
  String telepon = '0812 3456 7890';
  String email = 'siti.nurhaliza@gmail.com';
  
String avatarProfil = 'assets/images/avatar_siti.png';

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

  if (!mounted || hasil == null) return;

  setState(() {
    nama = hasil['nama'] ?? nama;
    telepon = hasil['telepon'] ?? telepon;
    email = hasil['email'] ?? email;
    avatarProfil = hasil['avatar'] ?? avatarProfil;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Profil berhasil diperbarui'),
    ),
  );
}

  bool notifikasiAktif = true;

  final Color pink = const Color(0xFFE0468F);
  final Color ungu = const Color(0xFF9449B8);

  void tampilPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  // ===================== EDIT PROFIL =====================

  void editProfil() {
    final namaController = TextEditingController(text: nama);
    final teleponController = TextEditingController(text: telepon);
    final emailController = TextEditingController(text: email);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Profil'),
        content: SizedBox(
          width: 350,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                    ),
                    validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Nama wajib diisi'
                            : null,
                  ),
                  TextFormField(
                    controller: teleponController,
                    decoration: const InputDecoration(
                      labelText: 'Nomor Telepon',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Nomor telepon wajib diisi'
                            : null,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        value != null &&
                                RegExp(
                                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                ).hasMatch(value.trim())
                            ? null
                            : 'Masukkan email yang valid',
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  nama = namaController.text.trim();
                  telepon = teleponController.text.trim();
                  email = emailController.text.trim();
                });

                Navigator.pop(dialogContext);
                tampilPesan('Profil berhasil diperbarui');
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    ).then((_) {
      namaController.dispose();
      teleponController.dispose();
      emailController.dispose();
    });
  }

  // ===================== NOTIFIKASI =====================

  void bukaNotifikasi() {
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Pengaturan Notifikasi'),
          content: SwitchListTile(
            title: const Text('Aktifkan Notifikasi'),
            value: notifikasiAktif,
            onChanged: (value) {
              setState(() => notifikasiAktif = value);
              setDialogState(() {});
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Selesai'),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== UBAH PASSWORD =====================

  void ubahPassword() {
    final passwordBaru = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ubah Kata Sandi'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: passwordBaru,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Kata Sandi Baru',
            ),
            validator: (value) =>
                value == null || value.length < 6
                    ? 'Minimal 6 karakter'
                    : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(dialogContext);
                tampilPesan(
                  'Simulasi perubahan kata sandi berhasil',
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    ).then((_) => passwordBaru.dispose());
  }

  // ===================== KARTU PESERTA =====================

  
Widget buildPesertaSaya(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Peserta Saya',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),
      Row(
        children: daftarPeserta.map((peserta) {
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfilPesertaPage(
                      peserta: peserta,
                    ),
                  ),
                );
              },
              child: Container(
                width: 85,
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black87,
                  ),
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor:
                          peserta.warnaAvatar,
                      child: Icon(
                        peserta.avatar,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      peserta.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      peserta.kategori,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ],
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // HEADER
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(
                          18, 38, 18, 30,
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

                            // KARTU PROFIL UTAMA
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(17),
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
  backgroundColor: const Color(0xFFFFD1AE),
  backgroundImage: AssetImage(avatarProfil),
),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          nama,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
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
                                                telepon,
                                                style: const TextStyle(
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
                                                email,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                ),
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                 
                                  IconButton(
                                    onPressed: bukaEditProfil,
                                    icon: const Icon(Icons.edit_square),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // BAGIAN PESERTA DAN PENGATURAN

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
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Peserta Saya',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // AVATAR RAKA DAN SARI
                              Row(
                                children: [
                                  ...daftarPeserta.map((peserta) {
  return Padding(
    padding: const EdgeInsets.only(right: 15),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilPesertaPage(
              peserta: peserta,
            ),
          ),
        );
      },
      child: Container(
        width: 91,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black87),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          children: [
           CircleAvatar(
  radius: 24,
  backgroundColor: peserta.warnaAvatar,
  backgroundImage: AssetImage(
    peserta.nama == 'Raka'
        ? 'assets/images/avatar_raka.png'
        : 'assets/images/avatar_sari.png',
  ),
),
            const SizedBox(height: 6),
            Text(
              peserta.nama,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              peserta.kategori,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    ),
  );
}),
                                ],
                              ),

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
  () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePasswordPage(),
      ),
    );
  },
),

                              
menuPengaturan(
  Icons.notifications_none,
  'Notifikasi',
  () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationPage(),
      ),
    );
  },
),

                              
menuPengaturan(
  Icons.smart_toy_outlined,
  'Chat dengan Asisten AI',
  () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AiAssistantPage(),
      ),
    );
  },
),

                              menuPengaturan(
                                Icons.logout,
                                'Logout',
                                () => tampilPesan(
                                  'Logout akan dihubungkan ke halaman Login',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // NAVIGASI BAWAH
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [pink, ungu],
                  ),
                ),
                child: BottomNavigationBar(
                  currentIndex: 2,
                  backgroundColor: Colors.transparent,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white70,
                  type: BottomNavigationBarType.fixed,
                  elevation: 0,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu_book_outlined),
                      label: 'Tentang',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                  onTap: (index) {
                    if (index != 2) {
                      tampilPesan(
                        'Halaman ini akan dihubungkan dengan halaman teman kelompok',
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
