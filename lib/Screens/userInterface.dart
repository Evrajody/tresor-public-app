import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tresor_public/Screens/widget.dart';
import 'package:tresor_public/Tools/data_colector.dart';
import 'package:tresor_public/Tools/http_services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as httpTool;

class UserInterface extends StatefulWidget {
  UserInterface({Key? key}) : super(key: key);

  @override
  _UserInterfaceState createState() => _UserInterfaceState();
}

class _UserInterfaceState extends State<UserInterface> {
  Timer? mytimer;
  bool connectionTester = false;
  String message = 'Chargement';
  final List<String> customAdresses = ([
    "marinsta.000webhostapp.com",
    "https://marinsta.000webhostapp.com/TresorPublic/FileStore"
  ]);

  List<PostingModelForFile> listOfUsers = [];
  ReceivePort receivePort = new ReceivePort();
  int? progress;

  void takeUsers() async {
    var users = await HttpService.fetchedUsers(); // données Json décodées
    print(users);
    for (Map<String, dynamic> item in users) {
      listOfUsers.add(PostingModelForFile.fromJson(item));
    }
  }

  void checkingConnectionTool() async {
    Timer(Duration(seconds: 10), () {
      message = "Aucune connection internet";
    });
    if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
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

  //  /storage/emulated/0/Android/data/com.example.tresor_public/files

  void fileDownloader(String? file) async {
    var savingPath = await getExternalStorageDirectory();
    var wantedSavingPath = savingPath!.parent.parent.parent.parent;
    Permission.storage.request().then((value) {
      if (value.isGranted) {
        FlutterDownloader.enqueue(
          url: '${customAdresses.last}/$file',
          savedDir: wantedSavingPath.path,
          showNotification: true,
          openFileFromNotification: true,

        );
      }
    });
  }

  void fileViewer(String? file) async {
    var url = '${customAdresses.last}/$file';
    httpTool.get(Uri.parse(url)).then((value) {
      print(value.bodyBytes);
    });
  }

  static downloadingCall(id, status, progress) {
    IsolateNameServer.lookupPortByName("name")!.send(progress);
  }

  @override
  void initState() {
    IsolateNameServer.registerPortWithName(receivePort.sendPort, "name");
    receivePort.listen((message) {
      setState(() {
        progress = message;
      });
    });
    super.initState();
    FlutterDownloader.registerCallback(downloadingCall);
    takeUsers();
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
                  ? Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        image: (connectionTester)
                            ? DecorationImage(
                                image: AssetImage(
                                    "assets/Coat_of_arms_of_Benin.png"),
                                repeat: ImageRepeat.repeat,
                              )
                            : null,
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Column(children: [
                              DataTable(
                                  columnSpacing: 10,
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Numéro',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Echeance',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Actions',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: List<DataRow>.generate(
                                      listOfUsers.length, (index) {
                                    PostingModelForFile user =
                                        listOfUsers[index];
                                    return DataRow(
                                        selected:
                                            (index % 2 == 0) ? true : false,
                                        cells: [
                                          DataCell(
                                              Text((index + 1).toString())),
                                          DataCell(Text(
                                              user.dateConcern.toString())),
                                          DataCell(Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextButton.icon(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.visibility,
                                                  size: 20,
                                                ),
                                                label: Text("Visualiser"),
                                              ),
                                              TextButton.icon(
                                                onPressed: () {
                                                  fileDownloader(listOfUsers
                                                      .elementAt(index)
                                                      .fileName);
                                                },
                                                icon: Icon(
                                                  Icons.download,
                                                  size: 20,
                                                ),
                                                label: Text("Telecharger"),
                                              ),
                                            ],
                                          )),
                                        ]);
                                  })),
                            ]),
                          ),
                        ],
                      ),
                    )
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
