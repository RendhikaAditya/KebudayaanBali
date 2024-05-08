import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../model/model_base.dart';
import '../model/model_sejarawan.dart';
import '../utils/api_url.dart';
import 'bottomNavBar.dart';

class AddSejarawan extends StatefulWidget {
  final Datum? data;

  const AddSejarawan(this.data, {Key? key}) : super(key: key);

  @override
  State<AddSejarawan> createState() => _AddSejarawanState();
}

class _AddSejarawanState extends State<AddSejarawan> {
  var logger = Logger();
  final _formKey = GlobalKey<FormState>();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  File? uploadimage;
  DateTime? _selectedDate= DateTime.now();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    // Jika data tidak null, isi _selectedDate dengan data.tanggalLahir
    // dan _selectedGender dengan data.jeniskelamin
    if (widget.data != null) {
      _selectedDate = widget.data!.tanggalLahir;
      _selectedGender = widget.data!.jenisKelamin;
    }
  }

  TextEditingController _controllerNama = TextEditingController();
  TextEditingController _controllerAsal = TextEditingController();
  TextEditingController _controllerDeskripsi = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _getImage() async {
    var choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      uploadimage = File(choosedimage!.path);
    });
  }

  Future<void> _tambahDataSejarawan() async {
    if (_formKey.currentState!.validate()) {
      final String apiUrl = '${ApiUrl().baseUrl}sejarawan.php';

      // Mengambil path file foto
      String imagePath = _image != null ? _image!.path : '';

      // Membuat request multipart
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      List<int> imageBytes = uploadimage!.readAsBytesSync();
      String baseImage = base64Encode(imageBytes);
      // Menambahkan data teks
      request.fields['action'] = 'tambah';
      request.fields['nama_sejarawan'] = _controllerNama.text;
      request.fields['foto_sejarawan'] = baseImage;
      request.fields['tanggal_lahir'] =
          _selectedDate.toString().substring(0, 10);
      request.fields['asal'] = _controllerAsal.text;
      request.fields['jenis_kelamin'] = _selectedGender.toString();
      request.fields['deskripsi'] = _controllerDeskripsi.text;

      // Menambahkan file foto
      if (imagePath.isNotEmpty) {
        request.files.add(
            await http.MultipartFile.fromPath('foto_sejarawan', imagePath));
      }

      try {
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          // Jika berhasil, periksa respons JSON
          Map<String, dynamic> jsonResponse = json.decode(response.body);
          if (jsonResponse['sukses']) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Data pegawai berhasil ditambahkan')),
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
              'Gagal menambahkan data sejarawan: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Gagal melakukan request: $e');
      }
    }
  }

  Future<void> _editDataSejarawan() async {
    if (_formKey.currentState!.validate()) {
      final String apiUrl = '${ApiUrl().baseUrl}sejarawan.php';


      // Mengambil path file foto
      String imagePath = _image != null ? _image!.path : '';

      // Membuat request multipart
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      //
      String baseImage ="";
      if(uploadimage!=null) {
        List<int> imageBytes = uploadimage!.readAsBytesSync();
        baseImage = base64Encode(imageBytes);
        logger.d("::::${baseImage} ::::");
      }

      // Menambahkan data teks
      request.fields['action'] = 'edit';
      request.fields['id'] = widget.data!.id!;
      request.fields['nama_sejarawan'] = _controllerNama.text;
      request.fields['foto_sejarawan'] = baseImage;
      request.fields['tanggal_lahir'] =
          _selectedDate.toString().substring(0, 10);
      request.fields['asal'] = _controllerAsal.text;
      request.fields['jenis_kelamin'] = _selectedGender.toString();
      request.fields['deskripsi'] = _controllerDeskripsi.text;

      // Menambahkan file foto
      if (imagePath.isNotEmpty) {
        request.files.add(
            await http.MultipartFile.fromPath('foto_sejarawan', imagePath));
      }

      try {
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          // Jika berhasil, periksa respons JSON
          Map<String, dynamic> jsonResponse = json.decode(response.body);
          if (jsonResponse['sukses']) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Data sejarawan berhasil diperbarui')),
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
              'Gagal memperbarui data sejarawan: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Gagal melakukan request: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    _controllerNama = widget.data != null
        ? TextEditingController(text: widget.data!.namaSejarawan.toString())
        : TextEditingController();
    _controllerAsal = widget.data != null
        ? TextEditingController(text: widget.data!.asal.toString())
        : TextEditingController();
    _controllerDeskripsi = widget.data != null
        ? TextEditingController(text: widget.data!.deskripsi.toString())
        : TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.data==null?'Tambah Data Sejarawan':'Edit Data Sejarawan',
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
          child: SingleChildScrollView(
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
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      onPressed: _getImage,
                      child: Text('Pilih Gambar'),
                    )
                  ],
                ),
                widget.data == null
                    ? uploadimage == null
                        ? Text(
                            'Belum ada gambar dipilih',
                            style: TextStyle(color: Colors.grey),
                          )
                        : Image.file(
                            File(uploadimage!.path),
                            height: 150,
                          )
                    : uploadimage == null
                        ? Image.network(
                            '${ApiUrl().baseUrl}${widget.data?.fotoSejarawan}',
                            width: 200,
                            height: 200,
                            fit: BoxFit
                                .cover, // Optional, untuk memastikan gambar terisi penuh dalam lingkaran
                          )
                        : Image.file(
                            File(uploadimage!.path),
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
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      onPressed: () => _selectDate(context),
                      child: Text('Select Date'),
                    )
                  ],
                ),
                Text(_selectedDate.toString().substring(0,10)),
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
                  onPressed: widget.data==null?_tambahDataSejarawan:_editDataSejarawan,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue[900],
                  ),
                  child: widget.data == null ? Text('Simpan') : Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
