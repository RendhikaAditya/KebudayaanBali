import 'package:flutter/material.dart';

import '../model/model_budaya.dart';
import '../utils/api_url.dart';

class PageDetailKebudayaan extends StatelessWidget {
  final Datum? data;

  const PageDetailKebudayaan(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          data!.namaKebudayaan!,
          style: TextStyle(
            color: Colors.white, // Warna putih
          ),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                '${ApiUrl().baseUrl}gambar/${data?.foto}',
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListTile(
            title: Text(
              data?.namaKebudayaan! ?? "",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              data?.deskripsi ?? "",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}