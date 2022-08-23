import 'package:flutter/material.dart';

class UtilDialog {

  static void presentLoader(BuildContext context,
      {String text = 'Aguarde...',
      bool barrierDismissible = false,
      bool willPop = true}) {
    showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (c) {
          return WillPopScope(
            onWillPop: () async {
              return willPop;
            },
            child: AlertDialog(
              content: Container(
                child: Row(
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      text,
                      style: TextStyle(fontSize: 18.0),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  static void presentAlert(BuildContext context, void print,
      {String title = '', String message = '', Function ok}) {
    showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: Text('$title'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text('$message'),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  // style: greenText,
                ),
                onPressed: ok != null ? ok : Navigator.of(context).pop,
              ),
            ],
          );
        });
  }

  static Future<DateTime> selectDate(BuildContext context,
      {DateTime initialDate}) async {
        final today = DateTime.now();
    return showDatePicker(
        context: context,
        initialDate:
            initialDate == null ? today.add(Duration(hours: 48)) : initialDate,
        firstDate: today.add(Duration(hours: 24)),
        lastDate: DateTime(2050));
  }

  static Future presentConfirm(BuildContext context,
      {String title = '',
      String message = '',
      @required Function yes,
      Function no}) {
    return showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: Text('$title'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text('$message'),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'NÃO',
                  // style: redText,
                ),
                onPressed: no,
              ),
              TextButton(
                child: Text(
                  'SIM',
                  // style: greenText,
                ),
                onPressed: yes,
              ),
            ],
          );
        });
  }
}