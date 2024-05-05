
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kebudayaan_bali/model/model_user.dart';
import 'package:kebudayaan_bali/utils/api_url.dart';
import 'package:kebudayaan_bali/utils/sesion_manager.dart';
import 'package:http/http.dart' as http;
import 'package:kebudayaan_bali/view/bottomNavBar.dart';
import 'package:kebudayaan_bali/view/register.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _txtUsername = TextEditingController();
  TextEditingController _txtPassword = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var logger = Logger();

  Future<ModelUser?> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        isLoading = true;
        http.Response res = await http.post(Uri.parse('${ApiUrl().baseUrl}auth.php'),
            body: {
              "login": "1",
              "username": _txtUsername.text,
              "password": _txtPassword.text,
            });

        ModelUser data = modelUserFromJson(res.body);
        logger.d("data :: ${data.pesan}");

        if (data!.sukses!) {
          setState(() {
            isLoading = false;

            sessionManager.saveSession(
              data!.sukses!,
              data!.data!.idUser!,
              data!.data!.username!,
              data!.data!.namaUser!,
              data!.data!.alamatUser!,
              data!.data!.nohpUser!,
            );
            sessionManager.getSession();
            sessionManager.getSession().then((value) {
              logger.d("nama :: ${sessionManager.userName}");
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${data.pesan}')));
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => BottomNavigation("home")),
                  (route) => false,
            );
          });
        } else {
          logger.d("Clasik");
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${data.pesan}')));
        }
      } catch (e) {
        logger.d("Error $e");
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('error: ${e.toString()}')));
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
                          _login();
                        },
                        color: Colors.blue[900],
                        child: Text('Login', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
                      },
                      child: Text(
                        'Belum punya akun? Silahkan daftar',
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
