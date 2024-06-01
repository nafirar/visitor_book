import 'package:flutter/material.dart';
import 'package:visitor_world/daftar_tamu.dart';
import 'package:visitor_world/pengunjung.dart';
import 'package:visitor_world/scanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Scanner(),
    Pengunjung(),
    DaftarTamu()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
        elevation: 5,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Scan'),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded),
            label: 'Pengunjung',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_people),
            label: 'Tamu',
          ),
        ],
      ),
    );
  }
}
