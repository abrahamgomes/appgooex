import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';

class NotificationHolder extends StatefulWidget {
  final Widget child;
  final Function(Map<String, dynamic>) onNotification;

  NotificationHolder({this.child, this.onNotification});

  @override
  _NotificationHolderState createState() => _NotificationHolderState();
}



class _NotificationHolderState extends State<NotificationHolder> {
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
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

    //_firebaseMessaging.getToken().then((String token) {
     // print('Token $token');
    //});

    // _firebaseMessaging.configure(
    //     onLaunch: (Map<String, dynamic> message) async {
    //   var data = message['data'];
    //   if (widget.onNotification != null)
    //     widget.onNotification.call({
    //       'type': data['type'],
    //       'title': data['title'],
    //       'message': data['message'],
    //       'data': data['data']
    //     });
    // }, onResume: (Map<String, dynamic> message) async {
    //   var data = message['data'];
    //   if (widget.onNotification != null)
    //     widget.onNotification.call({
    //       'type': data['type'],
    //       'title': data['title'],
    //       'message': data['message'],
    //       'data': data['data']
    //     });
    // }, onMessage: (Map<String, dynamic> message) async {
    //   var notification = message['notification'];
    //   var notificationPayload = message['data'];
    //   String payload = '';
    //   if (notificationPayload != null) {
    //     if (notificationPayload['type'] != null) {
    //       // payload = notificationPayload['type'].toString().toUpperCase();
    //       payload = json.encode(notificationPayload as Map);
    //     }
    //   }
    //   await _notifyMe(
    //       title: notification['title'],
    //       body: notification['body'],
    //       payload: payload);
    // });

   // _initializeNotifications();
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

  //     if (widget.onNotification != null)
  //       widget.onNotification.call({
  //         'type': payloadMap['type'],
  //         'title': payloadMap['title'],
  //         'message': payloadMap['message'],
  //         'data': payloadMap
  //       });

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

  @override
  Widget build(BuildContext context) => widget.child;
}
