import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../model/model_base.dart';
import '../utils/api_url.dart';
import 'bottomNavBar.dart';

class AddSejarawan extends StatefulWidget {
  const AddSejarawan({super.key});

  @override
  State<AddSejarawan> createState() => _AddSejarawanState();
}

class _AddSejarawanState extends State<AddSejarawan> {
  final _formKey = GlobalKey<FormState>();
  XFile? _image;
  DateTime _selectedDate = DateTime.now();
  String? _selectedGender;
  TextEditingController _controllerNama = TextEditingController();
  TextEditingController _controllerAsal = TextEditingController();
  TextEditingController _controllerDeskripsi = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  Future<void> _getImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future<void> _tambahDataPegawai() async {
    if (_formKey.currentState!.validate()) {
      final String apiUrl = '${ApiUrl().baseUrl}pegawai.php'; // Ganti dengan URL backend Anda

      final response = await http.post(Uri.parse(apiUrl), body: {
        'action': "tambah",
        'nama_sejarawan': _controllerNama.text,
        'foto_sejarawan': _image != null ? _image!.path : '',
        'tanggal_lahir': _selectedDate.toString().substring(0,10),
        'asal': _controllerAsal.text,
        'jenis_kelamin': _selectedGender.toString(),
        'deskripsi': _controllerDeskripsi.text,
      });

      if (response.statusCode == 200) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data pegawai berhasil ditambahkan')),
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigation("sejarawan")),
                (route) => false
        );

      } else {
        // Jika permintaan gagal, tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan data pegawai')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Data Sejarawan',
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _controllerNama,
                decoration: InputDecoration(labelText: 'Nama Pegawai'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama pegawai tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Foto Sejarawan"),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                    ),
                    onPressed: _getImage,
                    child: Text('Pilih Gambar'),
                  )
                ],
              ),
              _image == null
                  ? Text('Belum ada gambar dipilih',style: TextStyle(color: Colors.grey),)
                  : Image.file(
                      File(_image!.path),
                      height: 150,
                    ),
              SizedBox(height: 12.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Tanggal Lahir Sejarawan"),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                    ),
                    onPressed: ()=>_selectDate(context),
                    child: Text('Select Date'),
                  )
                ],
              ),
              _selectedDate == null
              ? Text("mm-dd-yyyy")
              : Text(_selectedDate.toString().substring(0,10)),
              TextFormField(
                controller: _controllerAsal,
                decoration: InputDecoration(labelText: 'Asal'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Asal tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              Text(
                'Pilih Jenis Kelamin:',
              ),
                DropdownButton<String>(
                value: _selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                items: <String>['Laki-laki', 'Perempuan']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 12),

              TextFormField(
                controller: _controllerDeskripsi,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue[900],
                ),
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
