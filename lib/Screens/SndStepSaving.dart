import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:tresor_public/Screens/widget.dart';

class TresorPublicRegisterStepSnd extends StatefulWidget {
  @override
  _TresorPublicRegisterStepSndState createState() =>
      _TresorPublicRegisterStepSndState();
}

class _TresorPublicRegisterStepSndState
    extends State<TresorPublicRegisterStepSnd> {
  GlobalKey<FormState> registerSndStep = GlobalKey<FormState>();
  Timer? mytimer;
  bool connectionTester = false;
  String message = 'Chargement';
  final List<String> customAdresses = (["marinsta.000webhostapp.com"]);

  void checkingConnectionTool() async {
    if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
      Timer(Duration(seconds: 10), () {
        message = "Aucune connection internet";
      });
      InternetAddress.lookup(customAdresses.first).then((result) {
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() {
            connectionTester = true;
          });
        } else {
          setState(() {
            connectionTester = false;
          });
        }
      }).catchError((onError) {
        setState(() {
          connectionTester = false;
        });
      });
    } else {
      setState(() {
        connectionTester = false;
      });
    }
  }

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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: (connectionTester)
                ? DecorationImage(
                    image: AssetImage("assets/Coat_of_arms_of_Benin.png"),
                    repeat: ImageRepeat.repeat,
                  )
                : null,
          ),
          child: Column(
            children: [
              toolbarDisplayer(context),
              SizedBox(height: 30),
              (connectionTester)
                  ? boxContentForRegisterStepSnd(context, registerSndStep)
                  : Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 3.7,
                        ),
                        CircularProgressIndicator.adaptive(strokeWidth: 3.5),
                        SizedBox(height: 15),
                        Text(
                          "$message",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
