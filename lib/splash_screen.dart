import 'dart:async';
import 'package:flutter/material.dart';
import 'package:visitor_world/homepage.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({ Key? key }) : super(key: key);
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}
class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openSplashScreen();
  }
  openSplashScreen() async {
    //bisa diganti beberapa detik sesuai keinginan
    var durasiSplash = const Duration(seconds: 3);
    return Timer(durasiSplash, () {
      //pindah ke halaman home
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) {
            return HomePage();
          })
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Buku Tamu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, fontStyle: FontStyle.italic )),
            SizedBox(height: 10,),
            Image.asset(
              "assets/images/spalsh.png",
              width: 300,
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}