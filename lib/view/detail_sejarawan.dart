import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../model/model_sejarawan.dart';
import '../utils/api_url.dart';
import 'add_sejarawan.dart';
import 'bottomNavBar.dart';

class DetailSejarawanPage extends StatelessWidget {
  final Datum? data;
  const DetailSejarawanPage(this.data, {super.key});


  void _hapusDataSejarawan(BuildContext context, String idSejarawan) async {
    final String apiUrl = '${ApiUrl().baseUrl}sejarawan.php';

    try {
      var response = await http.post(Uri.parse(apiUrl), body: {
        'id': idSejarawan,
        'action' : "hapus"
      });

      if (response.statusCode == 200) {
        // Jika berhasil, periksa respons JSON
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['sukses']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data sejarawan berhasil dihapus')),
          );
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => BottomNavigation("sejarawan")),
                  (route) => false);
        } else {
          // Tampilkan pesan error dari server
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['pesan'])),
          );
        }
      } else {
        // Tanggapan tidak berhasil, tampilkan kode status
        throw Exception(
            'Gagal menghapus data sejarawan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal melakukan request: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Sejarawan',
          style: TextStyle(
            color: Colors.white,
          ), // Ubah warna teks menjadi putih
        ),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child:ClipOval(
                    child: Image.network(
                      '${ApiUrl().baseUrl}${data?.fotoSejarawan}',
                      width: 200,
                      height: 200,
                      fit: BoxFit
                          .cover, // Optional, untuk memastikan gambar terisi penuh dalam lingkaran
                    ),
                  ),
                ),
                SizedBox(width: 16,),
                Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    Text("${data?.namaSejarawan}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    Text("${data?.jenisKelamin}")
                  ],
                )
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.place_outlined),
                SizedBox(width: 10),
                Text('${data?.asal}'),
              ],
            ),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.date_range_outlined),
                SizedBox(width: 10),
                Text('${data?.tanggalLahir.toString().substring(0,10)}'),
              ],
            ),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.description_outlined),
                SizedBox(width: 10),
                Text('${data?.deskripsi}'),
              ],
            ),
            SizedBox(height: 16,),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddSejarawan(data)),
                      );
                    },
                    child: Column(
                      children: [
                        Icon(Icons.edit_note),
                        Text("Edit Profil")
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){_hapusDataSejarawan(context, "${data?.id}");},
                    child: Column(
                      children: [
                        Icon(Icons.delete_outline),
                        Text("Hapus Profil")
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider()

          ],
        ),
      ),
    );
  }
}
