
import 'package:flutter/material.dart';
import 'change_password_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String nama = 'Siti Nurhaliza';
  String telepon = '0812 3456 7890';
  String email = 'siti.nurhaliza@gmail.com';
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

  Widget kartuPeserta(
    String nama,
    String kategori,
    String umur,
    String gambar,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(17),
      onTap: () => tampilPesan('Profil peserta $nama'),
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
              backgroundColor: Colors.pink.shade50,
              backgroundImage: AssetImage(gambar),
            ),
            const SizedBox(height: 6),
            Text(
              nama,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              kategori,
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              umur,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
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
                                  const CircleAvatar(
                                    radius: 37,
                                    backgroundColor:
                                        Color(0xFFFFD1AE),
                                    backgroundImage: AssetImage(
                                      'assets/images/avatar_siti.png',
                                    ),
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
                                    onPressed: editProfil,
                                    icon: const Icon(
                                      Icons.edit_square,
                                    ),
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
                                  kartuPeserta(
                                    'Raka',
                                    'Balita',
                                    '3 tahun',
                                    'assets/images/avatar_raka.png',
                                  ),
                                  const SizedBox(width: 15),
                                  kartuPeserta(
                                    'Sari',
                                    'Lansia',
                                    '67 Tahun',
                                    'assets/images/avatar_sari.png',
                                  ),
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
                                  // Implement notification logic here
                                },
                              ),
                              menuPengaturan(
                                Icons.smart_toy_outlined,
                                'Chat dengan Asisten AI',
                                () => tampilPesan(
                                  'Fitur AI direncanakan untuk pengembangan berikutnya',
                                ),
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
