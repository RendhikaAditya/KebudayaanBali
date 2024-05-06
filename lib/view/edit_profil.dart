import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import '../model/model_base.dart';
import '../utils/api_url.dart';
import '../utils/sesion_manager.dart';
import 'bottomNavBar.dart';

class EditProfil extends StatefulWidget {
  const EditProfil({super.key});

  @override
  State<EditProfil> createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sessionManager.getSession();
    sessionManager.getSession().then((value) {
      // logger.d("alamat :: ${sessionManager.alamat}");
      // nama = sessionManager.fullname;
      // username = sessionManager.userName;
      // alamat = sessionManager.alamat;
      // noHp = sessionManager.nohp;
    });
  }


  TextEditingController _txtNama = TextEditingController(text: '${sessionManager.fullname}');
  TextEditingController _txtAlamat = TextEditingController(text: '${sessionManager.alamat}');
  TextEditingController _txtNoTelpon = TextEditingController(text: '${sessionManager.nohp}');
  TextEditingController _txtUsername = TextEditingController(text: '${sessionManager.userName}');
  TextEditingController _txtPassword = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var logger = Logger();

  Future<ModelBase?> editData(String userId) async {
    if (_formKey.currentState!.validate()) {
      try {
        isLoading = true;
        http.Response res = await http.post(Uri.parse('${ApiUrl().baseUrl}auth.php'), body: {
          "edit_user": "1",
          "id_user": userId,
          "username": _txtUsername.text,
          "password": _txtPassword.text,
          "nama_user": _txtNama.text,
          "alamat_user": _txtAlamat.text,
          "nohp_user": _txtNoTelpon.text
        });
        ModelBase data = modelBaseFromJson(res.body);

        sessionManager.saveSession(
            data!.sukses!,
            sessionManager.idUser as String,
            _txtUsername.text,
            _txtNama.text,
            _txtAlamat.text,
            _txtNoTelpon.text
        );
        if (data.sukses) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(data.pesan)));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigation("profil")),
                (route) => false,
          );
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(data.pesan)));
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profil',
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
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Daftar",style: TextStyle( color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _txtNama,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _txtAlamat,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _txtNoTelpon,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor Telepon tidak boleh kosong';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _txtUsername,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                obscureText: true,
                controller: _txtPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : MaterialButton(
                minWidth: 150,
                height: 45,
                onPressed: () {
                  editData(sessionManager!.idUser!);
                },
                color: Colors.blue[900],
                child: Text('Edit', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
