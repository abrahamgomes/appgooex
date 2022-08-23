import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gooex_mobile/src/pages/criar_conta/criar_conta_page.dart';
import 'package:gooex_mobile/src/pages/login/login_page.dart';
import 'package:gooex_mobile/src/widgets/confirmar_desembarque.dart';
import 'package:gooex_mobile/src/widgets/notification_holder.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(MyApp());
}

Route generatePage(child) {
  return MaterialPageRoute(builder: (context) => child);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      title: 'Gooex',
      theme: ThemeData(fontFamily: 'Rubik', primarySwatch: Colors.blueGrey),
      home: NotificationHolder(
        onNotification: (notificationMap) async {
          print('NotificationHolder "onNotification"');
          print(notificationMap);

          if (notificationMap['data'] != null) {
            Map<String, dynamic> data;

            try {
              data = notificationMap['data'] as Map<String, dynamic>;
            } on TypeError {
              data = json.decode(notificationMap['data'] as String)
                  as Map<String, dynamic>;
            }

            print(data);

            // TODO: Corrigir ortografia
            if (data['type'] == 'confimar_embarque') {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('confirmar_desembarque', true);
              await prefs.setString(
                  'confirmacao_data', DateTime.now().toIso8601String());
              await prefs.setString('email_transportador', data['email']);
            }
          }
        },
        child: LoginPage(),
      ),
    );
  }

  Widget build2(BuildContext context) {
    return NotificationHolder(
      onNotification: (notificationMap) async {
        print('NotificationHolder "onNotification"');
        print(notificationMap);

        if (notificationMap['data'] != null) {
          Map<String, dynamic> data;

          try {
            data = notificationMap['data'] as Map<String, dynamic>;
          } on TypeError {
            data = json.decode(notificationMap['data'] as String) 
                as Map<String, dynamic>;
          }

          // TODO: Corrigir ortografia
          if (data['type'] == 'confimar_embarque') {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('confirmar_desembarque', true);
            await prefs.setString(
                'confirmacao_data', DateTime.now().toIso8601String());
            await prefs.setString('email_transportador', data['email']);
          }
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale('pt', 'BR')],
        title: 'Gooex',
        theme: ThemeData(fontFamily: 'Rubik', primarySwatch: Colors.deepOrange),
        home: LoginPage(),
      ),
    );
  }
}
