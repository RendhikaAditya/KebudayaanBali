// // // To parse this JSON data, do
// // //
// // //     final modelBerita = modelBeritaFromJson(jsonString);

import 'dart:convert';

ModelGaleri modelGaleriFromJson(String str) => ModelGaleri.fromJson(json.decode(str));

String modelGaleriToJson(ModelGaleri data) => json.encode(data.toJson());

class ModelGaleri {
  bool sukses;
  int status;
  String pesan;
  List<Datum> data;

  ModelGaleri({
    required this.sukses,
    required this.status,
    required this.pesan,
    required this.data,
  });

  factory ModelGaleri.fromJson(Map<String, dynamic> json) => ModelGaleri(
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
  String idGaleri;
  String foto;

  Datum({
    required this.idGaleri,
    required this.foto,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    idGaleri: json["id_galeri"],
    foto: json["foto"],
  );

  Map<String, dynamic> toJson() => {
    "id_galeri": idGaleri,
    "foto": foto,
  };
}


// import 'dart:convert';

// class ModelGaleri {
//   final String id_galeri;
//   final String foto;

//   ModelGaleri({
//     required this.id_galeri,
//     required this.foto,
//   });

//   factory ModelGaleri.fromJson(Map<String, dynamic> json) {
//     return ModelGaleri(
//       id_galeri: json['id'] as String,
//       foto: json['foto'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id_galeri,
//       'foto': foto,
//     };
//   }
// }
