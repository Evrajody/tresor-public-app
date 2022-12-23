import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tresor_public/TresorPublicHome.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

FlutterLocalNotificationsPlugin notifPlugin = FlutterLocalNotificationsPlugin();
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'id',
  'name',
  'description',
  importance: Importance.max,
);

Future<void> messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  notifPlugin.initialize(
    InitializationSettings(
      android: AndroidInitializationSettings('launcher_icon'),
      iOS: IOSInitializationSettings(),
    ),
  );

  if (notification != null && android != null) {
    notifPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            priority: Priority.max,
            icon: "launcher_icon",
          ),
          iOS: IOSNotificationDetails(),
        ));
  }
}

getMessage() async {
  await Firebase.initializeApp();
  String? msg = await FirebaseMessaging.instance.getToken();
  print(msg);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: true);
  // FirebaseMessaging.onBackgroundMessage(messageHandler);
  //getMessage();
  await notifPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(TresorPublicApp());
}

class TresorPublicApp extends StatefulWidget {
  TresorPublicApp({Key? key}) : super(key: key);
  @override
  _TresorPublicAppState createState() => _TresorPublicAppState();
}

class _TresorPublicAppState extends State<TresorPublicApp> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen(messageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(messageHandler);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tresor Public",
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TresorPublicHome(),
    );
  }
}
