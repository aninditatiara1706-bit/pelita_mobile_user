import 'package:flutter/material.dart';
import '../../profil peserta/models/peserta_model.dart';

class ProfileData {
  final String nama, telepon, email, avatar;
  const ProfileData({required this.nama, required this.telepon, required this.email, required this.avatar});
}

class ProfilePesertaMapper {
  static Peserta fromJson(Map<String, dynamic> peserta) => Peserta(
    id: (peserta['id'] ?? '').toString(),
    nama: (peserta['nama'] ?? '-').toString(),
    kategori: kategori((peserta['kategori'] ?? '').toString()),
    tanggalLahir: tanggal(peserta['tanggalLahir']),
    jenisKelamin: gender((peserta['jenisKelamin'] ?? '').toString()),
    namaOrangTua: (peserta['namaWali'] ?? peserta['namaOrangTua'] ?? '-').toString(),
    nik: (peserta['nik'] ?? '-').toString(),
    terakhirDiperiksa: '-',
    avatar: icon((peserta['kategori'] ?? '').toString()),
    warnaAvatar: warna((peserta['kategori'] ?? '').toString()),
    berat: const [], tinggiBadan: const [], lingkarKepala: const [],
    sistolik: const [], diastolik: const [], gulaDarah: const [], denyutNadi: const [],
  );

  static String kategori(String value) => switch(value.toUpperCase()) {
    'BALITA' => 'Balita', 'IBU_HAMIL' => 'Ibu Hamil', 'LANSIA' => 'Lansia', _ => value
  };
  static String gender(String value) => switch(value.toUpperCase()) {
    'LAKI_LAKI' => 'Laki-Laki', 'PEREMPUAN' => 'Perempuan', _ => value
  };
  static String tanggal(dynamic value) {
    if (value == null) return '-';
    try { final d=DateTime.parse(value.toString()); return '${d.day.toString().padLeft(2,'0')}-${d.month.toString().padLeft(2,'0')}-${d.year}'; }
    catch (_) { return value.toString(); }
  }
  static IconData icon(String value) => switch(value.toUpperCase()) {
    'BALITA' => Icons.child_care, 'IBU_HAMIL' => Icons.pregnant_woman, 'LANSIA' => Icons.elderly, _ => Icons.person
  };
  static Color warna(String value) => switch(value.toUpperCase()) {
    'BALITA' => const Color(0xFFFFD5C2), 'IBU_HAMIL' => const Color(0xFFE9D5FF), 'LANSIA' => const Color(0xFFE8B8AD), _ => const Color(0xFFDCC6F0)
  };
}
