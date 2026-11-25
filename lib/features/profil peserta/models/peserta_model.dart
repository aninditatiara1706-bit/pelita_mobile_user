import 'package:flutter/material.dart';

class Peserta {
  final String id;
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

  final List<double> sistolik;
  final List<double> diastolik;
  final List<double> gulaDarah;
  final List<double> denyutNadi;

  const Peserta({
    required this.id,
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