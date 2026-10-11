
# PELITA Mobile User

Aplikasi mobile **PELITA** untuk pengguna layanan Posyandu, dikembangkan menggunakan Flutter sebagai bagian dari proyek kelompok.

## Teknologi

- Flutter
- Dart

## Fitur

### Fitur yang sedang dikembangkan
- Login dan pendaftaran pengguna
- Beranda pengguna
- Data anggota keluarga
- Pendaftaran layanan Posyandu
- Informasi jadwal Posyandu
- Nomor antrean
- Notifikasi
- Riwayat pelayanan

### Halaman Profil Saya
- Menampilkan informasi profil pengguna
- Menampilkan anggota keluarga atau peserta
- Mengedit informasi profil
- Halaman ubah kata sandi dengan validasi form
- Pengaturan notifikasi
- Menu Chat dengan Asisten AI (placeholder)
- Menu Logout (belum terhubung ke autentikasi)

> Catatan: Beberapa fitur masih menggunakan data dummy dan simulasi untuk kebutuhan demo UTS.

## Cara Menjalankan

Pastikan Flutter sudah terpasang.

1. Clone repository:

   ```bash
   git clone https://github.com/aninditatiara1706-bit/pelita_mobile_user.git
   ```

2. Masuk ke folder project:

   ```bash
   cd pelita_mobile_user
   ```

3. Instal dependency:

   ```bash
   flutter pub get
   ```

4. Jalankan aplikasi:

   ```bash
   flutter run -d chrome
   ```

## Struktur Project

```text
lib/
├── main.dart
└── pages/
    ├── profile_page.dart
    └── change_password_page.dart

assets/
└── images/
    ├── avatar_siti.png
    ├── avatar_raka.png
    └── avatar_sari.png
```

## Pengembangan

Project ini dikerjakan secara berkelompok. Setiap anggota mengembangkan fitur pada file atau branch masing-masing sebelum digabungkan ke aplikasi utama.
