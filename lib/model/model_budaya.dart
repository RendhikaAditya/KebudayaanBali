// To parse this JSON data, do
//
//     final modelBudaya = modelBudayaFromJson(jsonString);

import 'dart:convert';

ModelBudaya modelBudayaFromJson(String str) => ModelBudaya.fromJson(json.decode(str));

String modelBudayaToJson(ModelBudaya data) => json.encode(data.toJson());

class ModelBudaya {
  bool? sukses;
  int? status;
  String? pesan;
  List<Datum>? data;

  ModelBudaya({
    this.sukses,
    this.status,
    this.pesan,
    this.data,
  });

  factory ModelBudaya.fromJson(Map<String, dynamic> json) => ModelBudaya(
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
  String? namaKebudayaan;
  String? deskripsi;
  String? foto;

  Datum({
    this.id,
    this.namaKebudayaan,
    this.deskripsi,
    this.foto,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    namaKebudayaan: json["nama_kebudayaan"],
    deskripsi: json["deskripsi"],
    foto: json["foto"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama_kebudayaan": namaKebudayaan,
    "deskripsi": deskripsi,
    "foto": foto,
  };
}
