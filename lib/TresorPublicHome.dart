import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:tresor_public/Screens/Portails/Ecollectivite.dart';
import 'package:tresor_public/Screens/Portails/Equittance.dart';
import 'package:tresor_public/Screens/Portails/TresorPublicChange.dart';
import 'package:tresor_public/Screens/Portails/TresorPublicPension.dart';
import 'package:tresor_public/Screens/Portails/TresorPublicTitre.dart';
import 'package:tresor_public/Screens/TresorPublicLogin.dart';
import 'package:tresor_public/Screens/widget.dart';

class TresorPublicHome extends StatefulWidget {
  TresorPublicHome({Key? key}) : super(key: key);

  @override
  _TresorPublicHomeState createState() => _TresorPublicHomeState();
}

class _TresorPublicHomeState extends State<TresorPublicHome> {
  Timer? mytimer;
  bool connectionTester = false;
  String message = 'Chargement';

  final List<String> customAdresses = (["marinsta.000webhostapp.com"]);

  @override
  void initState() {
    super.initState();
    mytimer = Timer.periodic(
        Duration(seconds: 3), (Timer t) => checkingConnectionTool());
  }

  @override
  void dispose() {
    mytimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[900],
      ),
      drawer: Drawer(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[900],
                image: DecorationImage(
                  image: AssetImage("assets/bkg.png"),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              height: 100,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/dgtcp-1_tiny-new.png"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            connectionTester
                ? Column(
                    children: [
                      eServicesDisplayer(
                        context,
                        "Portail fiche de paie",
                        TresorPublicLogin(),
                      ),
                      eServicesDisplayer(
                        context,
                        "Portail suivi titre",
                        TresorPublicTitre(),
                      ),
                      eServicesDisplayer(
                        context,
                        "Portail suivie change",
                        TresorPublicChange(),
                      ),
                      eServicesDisplayer(
                        context,
                        "Portail fiche pension",
                        TresorPublicPension(),
                      ),
                      eServicesDisplayer(
                        context,
                        "Portail eQuittance",
                        Equittance(),
                      ),
                      eServicesDisplayer(
                        context,
                        "Portail eCollectivité",
                        Ecollectivite(),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3.5,
                      ),
                      CircularProgressIndicator.adaptive(strokeWidth: 3.5),
                      SizedBox(height: 15),
                      Text(
                        "$message",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
