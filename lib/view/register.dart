
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kebudayaan_bali/model/model_user.dart';
import 'package:kebudayaan_bali/utils/api_url.dart';
import 'package:kebudayaan_bali/utils/sesion_manager.dart';
import 'package:http/http.dart' as http;
import 'package:kebudayaan_bali/view/bottomNavBar.dart';
import 'package:kebudayaan_bali/view/login.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../model/model_base.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _txtNama = TextEditingController();
  TextEditingController _txtAlamat = TextEditingController();
  TextEditingController _txtNoTelpon = TextEditingController();
  TextEditingController _txtUsername = TextEditingController();
  TextEditingController _txtPassword = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var logger = Logger();

  Future<ModelBase?> register() async {
    if (_formKey.currentState!.validate()) {
      try {
        isLoading = true;
        http.Response res =
        await http.post(Uri.parse('${ApiUrl().baseUrl}auth.php'), body: {
          "tambah_user": "1",
          "username": _txtUsername.text,
          "password": _txtPassword.text,
          "nama_user": _txtNama.text,
          "alamat_user": _txtAlamat.text,
          "nohp_user": _txtNoTelpon.text
        });
        ModelBase data = modelBaseFromJson(res.body);
        if (data.sukses) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(data.pesan)));
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false);
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
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('image/backround.png'),
              fit: BoxFit.cover, // Sesuaikan dengan kebutuhan Anda
            ),
          ),
          child: Center(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Login",style: TextStyle( color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
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
                      child: TextFormField(
                        obscureText: true,
                        controller: _txtPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          return null;
                        },
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
                          register();
                        },
                        color: Colors.blue[900],
                        child: Text('Register', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        'Sudah punya akun? Silahkan login disini',
                        style: TextStyle(
                          color: Colors.blue[900],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
          ),
        ),
      );
  }
}
