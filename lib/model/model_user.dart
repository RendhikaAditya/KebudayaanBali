// To parse this JSON data, do
//
//     final modelUser = modelUserFromJson(jsonString);

import 'dart:convert';

ModelUser modelUserFromJson(String str) => ModelUser.fromJson(json.decode(str));

String modelUserToJson(ModelUser data) => json.encode(data.toJson());

class ModelUser {
  bool? sukses;
  int? status;
  String? pesan;
  Data? data;

  ModelUser({
    this.sukses,
    this.status,
    this.pesan,
    this.data,
  });

  factory ModelUser.fromJson(Map<String, dynamic> json) => ModelUser(
    sukses: json["sukses"],
    status: json["status"],
    pesan: json["pesan"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "sukses": sukses,
    "status": status,
    "pesan": pesan,
    "data": data?.toJson(),
  };
}

class Data {
  String? idUser;
  String? namaUser;
  String? alamatUser;
  String? nohpUser;
  String? username;
  String? password;

  Data({
    this.idUser,
    this.namaUser,
    this.alamatUser,
    this.nohpUser,
    this.username,
    this.password,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    idUser: json["id_user"],
    namaUser: json["nama_user"],
    alamatUser: json["alamat_user"],
    nohpUser: json["nohp_user"],
    username: json["username"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "id_user": idUser,
    "nama_user": namaUser,
    "alamat_user": alamatUser,
    "nohp_user": nohpUser,
    "username": username,
    "password": password,
  };
}
