import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kebudayaan_bali/view/edit_profil.dart';
import 'package:logger/logger.dart';

import '../utils/sesion_manager.dart';
import 'login.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _Profil();
}

class _Profil extends State<Profil> {
  var logger = Logger();
  String? nama;
  String? username;
  String? alamat;
  String? noHp;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sessionManager.getSession();
    sessionManager.getSession().then((value) {
      logger.d("alamat :: ${sessionManager.alamat}");
      nama = sessionManager.fullname;
      username = sessionManager.userName;
      alamat = sessionManager.alamat;
      noHp = sessionManager.nohp;
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 50,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '${sessionManager.fullname}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${sessionManager.userName}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'No. HP:',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Text(
              '${sessionManager.nohp}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Alamat:',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Text(
              '${sessionManager.alamat}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: MaterialButton(
                minWidth: 150,
                height: 45,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfil())
                  );
                },
                color: Colors.amber[900],
                child: Text(
                  'Edit Profil',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: MaterialButton(
                minWidth: 150,
                height: 45,
                onPressed: () {
                  sessionManager.clearSession();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false
                  );
                },
                color: Colors.red[900],
                child: Text('Logout', style: TextStyle(color: Colors.white)),
              ),
            )

          ]),
        ),
      ),
    );
  }
}
