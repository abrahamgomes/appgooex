import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/widgets/confirmar_desembarque.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppScaffold extends StatefulWidget {
  final Widget body, drawer, floatingActionButton;

  AppScaffold({this.body, this.drawer, this.floatingActionButton});

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
/*   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); */
  var initializeSettingsAndroid;
  var initializeSettingsIOS;
  var initializeSettings;

  var vibrationPattern = Int64List(4);

  @override
  void initState() {
    super.initState();

    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 1500;
    vibrationPattern[3] = 2000;

  //   _firebaseMessaging.configure(onResume: (message) async {
  //     var notification = message['data'];
  //     print('AppScaffold.resume: $notification');

  //     // await _notifyMe(
  //     //     title: 'teste', body: 'xvauyscvuy', payload: 'cbsdcoisbc');

  //     if (notification != null) {
  //       var data = json.decode(notification['data']);
  //       print('\n\nData: $data\n\n');
  //       if (notification['type'] != null &&
  //           notification['type'] == 'confimar_embarque') {
  //         if (loginStore.usuario.email != data['email']) {
  //           SharedPreferences prefs = await SharedPreferences.getInstance();
  //           await prefs.setBool('confirmar_desembarque', true);
  //           await prefs.setString(
  //               'confirmacao_data', DateTime.now().toIso8601String());
  //           await prefs.setString('email_transportador', data['email']);
  //           return;
  //         }
  //         Navigator.of(context).push(
  //             MaterialPageRoute(builder: (_) => ConfirmarDesembarquePage()));
  //       }
  //     }

  //     print('AppScaffold.resume: $message');
  //   }, onMessage: (message) async {
  //     print('AppScaffold.message: $message');
  //     var notification = message['notification'];
  //     var payload = message['data'];

  //      await _notifyMe(
  //         title: notification['title'], body: notification['body'], payload: 'cbsdcoisbc');

  //     if (payload['type'] != null && payload['type'] == 'confimar_embarque') {
  //       var data = json.decode(payload['data']);
  //       // String email = data['email'];
  //       if (loginStore.usuario.email != data['email']) {
  //         SharedPreferences prefs = await SharedPreferences.getInstance();
  //         await prefs.setBool('confirmar_desembarque', true);
  //         await prefs.setString(
  //             'confirmacao_data', DateTime.now().toIso8601String());
  //         await prefs.setString('email_transportador', data['email']);
  //         return;
  //       }
  //       Navigator.of(context).push(
  //           MaterialPageRoute(builder: (_) => ConfirmarDesembarquePage()));
  //     }

  //     print('AppScaffold.message: $payload');
  //   });

  //   _initializeNotifications();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.drawer,
      body: Stack(
        children: <Widget>[
          Container(),
          widget.body,
          Positioned(
              top: 100,
              left: 100,
              child: TextButton(
                  onPressed: () async {
                    // await _notifyMe(
                    //     title: 'teste',
                    //     body: 'xvauyscvuy',
                    //     payload: 'cbsdcoisbc');
                  },
                  style:TextButton.styleFrom(backgroundColor: Colors.transparent),

                  ))
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }

  // _initializeNotifications() {
  //   initializeSettingsAndroid =
  //       AndroidInitializationSettings('@drawable/ic_stat_notification');
  //   initializeSettingsIOS = IOSInitializationSettings(
  //       onDidReceiveLocalNotification:
  //           (int id, String title, String body, String payload) async {});
  //   initializeSettings = InitializationSettings(
  //       initializeSettingsAndroid, initializeSettingsIOS);
  //   _flutterLocalNotificationsPlugin.initialize(initializeSettings,
  //       onSelectNotification: (String payload) async {
  //     Map<String, dynamic> payloadMap = json.decode(payload);
  //     if (payloadMap['type'] != null &&
  //         payloadMap['type'] == 'confimar_embarque') {
  //       loginStore.setConfirmacaoDesembarque(true);
  //     }

  //     // print('payload da notificação $payload');
  //     return Future.value('Awesome');
  //   });
  // }

  // Future<void> _notifyMe(
  //     {String title = 'Title',
  //     String body = 'Body',
  //     String payload = 'Default payload'}) async {
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'your channel id', 'your channel name', 'your channel description',
  //       vibrationPattern: vibrationPattern,
  //       color: Colors.deepOrange,
  //       importance: Importance.Max,
  //       priority: Priority.High,
  //       ticker: 'ticker');
  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   await _flutterLocalNotificationsPlugin
  //       .show(0, title, body, platformChannelSpecifics, payload: payload);
  // }
}
