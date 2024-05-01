import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class AddSejarawan extends StatefulWidget {
  const AddSejarawan({super.key});

  @override
  State<AddSejarawan> createState() => _AddSejarawanState();
}

class _AddSejarawanState extends State<AddSejarawan> {
  final _formKey = GlobalKey<FormState>();
  XFile? _image;

  Future<void> _getImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  TextEditingController _controllerNama = TextEditingController();
  TextEditingController _controllerNoBP = TextEditingController();
  TextEditingController _controllerNoHP = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();

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
              TextFormField(
                controller: _controllerNoBP,
                decoration: InputDecoration(labelText: 'Nomor BP'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor BP tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _controllerNoHP,
                decoration: InputDecoration(labelText: 'Nomor HP'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor HP tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _controllerEmail,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  // Validasi email dengan regex sederhana
                  if (!RegExp(
                          r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
                      .hasMatch(value)) {
                    return 'Masukkan email yang valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 5.0),
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
