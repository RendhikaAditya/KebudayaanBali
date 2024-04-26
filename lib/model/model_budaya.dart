// To parse this JSON data, do
//
//     final modelBerita = modelBeritaFromJson(jsonString);

import 'dart:convert';

ModelBudaya modelBudayaFromJson(String str) => ModelBudaya.fromJson(json.decode(str));

String modelBudayaToJson(ModelBudaya data) => json.encode(data.toJson());

class ModelBudaya {
  bool sukses;
  int status;
  String pesan;
  List<Datum> data;

  ModelBudaya({
    required this.sukses,
    required this.status,
    required this.pesan,
    required this.data,
  });

  factory ModelBudaya.fromJson(Map<String, dynamic> json) => ModelBudaya(
    sukses: json["sukses"],
    status: json["status"],
    pesan: json["pesan"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sukses": sukses,
    "status": status,
    "pesan": pesan,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String idBudaya;
  String judulBudaya;
  String kontenBudaya;
  String gambarBudaya;

  Datum({
    required this.idBudaya,
    required this.judulBudaya,
    required this.kontenBudaya,
    required this.gambarBudaya,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    idBudaya: json["id_budaya"],
    judulBudaya: json["nama_kebudayaan"],
    kontenBudaya: json["deskripsi"],
    gambarBudaya: json["foto"],
  );

  Map<String, dynamic> toJson() => {
    "id_budaya": idBudaya,
    "nama_kebudayaan": judulBudaya,
    "deskripsi": kontenBudaya,
    "foto": gambarBudaya,
  };
}
