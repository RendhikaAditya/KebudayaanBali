// To parse this JSON data, do
//
//     final modelSejarawan = modelSejarawanFromJson(jsonString);

import 'dart:convert';

ModelSejarawan modelSejarawanFromJson(String str) => ModelSejarawan.fromJson(json.decode(str));

String modelSejarawanToJson(ModelSejarawan data) => json.encode(data.toJson());

class ModelSejarawan {
  bool? sukses;
  int? status;
  String? pesan;
  List<Datum>? data;

  ModelSejarawan({
    this.sukses,
    this.status,
    this.pesan,
    this.data,
  });

  factory ModelSejarawan.fromJson(Map<String, dynamic> json) => ModelSejarawan(
    sukses: json["sukses"],
    status: json["status"],
    pesan: json["pesan"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sukses": sukses,
    "status": status,
    "pesan": pesan,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  String? namaSejarawan;
  String? fotoSejarawan;
  DateTime? tanggalLahir;
  String? asal;
  String? jenisKelamin;
  String? deskripsi;

  Datum({
    this.id,
    this.namaSejarawan,
    this.fotoSejarawan,
    this.tanggalLahir,
    this.asal,
    this.jenisKelamin,
    this.deskripsi,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    namaSejarawan: json["nama_sejarawan"],
    fotoSejarawan: json["foto_sejarawan"],
    tanggalLahir: json["tanggal_lahir"] == null ? null : DateTime.parse(json["tanggal_lahir"]),
    asal: json["asal"],
    jenisKelamin: json["jenis_kelamin"],
    deskripsi: json["deskripsi"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama_sejarawan": namaSejarawan,
    "foto_sejarawan": fotoSejarawan,
    "tanggal_lahir": "${tanggalLahir!.year.toString().padLeft(4, '0')}-${tanggalLahir!.month.toString().padLeft(2, '0')}-${tanggalLahir!.day.toString().padLeft(2, '0')}",
    "asal": asal,
    "jenis_kelamin": jenisKelamin,
    "deskripsi": deskripsi,
  };
}
