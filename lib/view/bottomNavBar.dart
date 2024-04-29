import 'package:flutter/material.dart';
import 'package:kebudayaan_bali/view/pegawai.dart';
import 'package:kebudayaan_bali/view/profil.dart';
import 'package:logger/logger.dart';

import 'galeri.dart';
import 'home.dart';

class BottomNavigation extends StatefulWidget {
  final String initialRoute;

  BottomNavigation(this.initialRoute);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  String initialRoute = "";
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    var logger = Logger();
    initialRoute = widget.initialRoute;
    logger.d("Data dari push :: $initialRoute");

    // Pengecekan nilai initialRoute
    if (initialRoute == "pegawai") {
      setState(() {
        _selectedIndex = 2;
      });
    }else if(initialRoute=="profil"){
      setState(() {
        _selectedIndex = 3;
      });
    } else {
      setState(() {
        _selectedIndex = 0;
      });
    }
  }


  final List<Widget> _pages = [
    HomePage(),
    GaleriPage(),
    PegawaiPage(),
    Profil(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _selectedIndex == 0 ? Colors.blue[900] : Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library, color: _selectedIndex == 1 ? Colors.blue[900] : Colors.grey),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people, color: _selectedIndex == 2 ? Colors.blue[900] : Colors.grey),
            label: 'Employee',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _selectedIndex == 3 ? Colors.blue[900] : Colors.grey),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[900],
        onTap: _onItemTapped,
      ),
    );
  }
}
