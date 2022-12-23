import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tresor_public/TresorPublicHome.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _splashedToHome() async {
    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => TresorPublicHome()));
  }

  @override
  void initState() {
    super.initState();
    _splashedToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/logo_DGTCP.png", width: 200, height: 200),
          Center(
            child: Text(
              'Trésor Public',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
