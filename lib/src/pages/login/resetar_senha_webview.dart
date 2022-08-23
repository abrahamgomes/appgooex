import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ResetarSenhaWebView extends StatefulWidget {

  final String paymentUrl;
  final bool isSandbox;

  ResetarSenhaWebView({this.paymentUrl, this.isSandbox});

  @override
  _ResetarSenhaWebViewState createState() => _ResetarSenhaWebViewState();
}

class _ResetarSenhaWebViewState extends State<ResetarSenhaWebView> {

  Completer<WebViewController> _controller = Completer<WebViewController>();
  bool first = false;

  @override
  void initState() {
    print('Abrindo ${widget.paymentUrl}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
       return Scaffold(
         floatingActionButton: FloatingActionButton(
           onPressed: () {
             Navigator.of(context).pop();
           },
           child: Icon(Icons.close),
         ),

      body: SafeArea(
              child: Builder(
          builder: (BuildContext context) {
            return WebView(
              
              initialUrl: 'https://app.gooex.com.br/api/1.0/reset-password',
              javascriptMode: JavascriptMode.unrestricted,
              userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36',
              navigationDelegate: (NavigationRequest req) {
                if(req.url.startsWith('https://app.gooex.com.br/api/1.0/reset-password/done')) {
                  Navigator.of(context).pop();
                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              },
              onWebResourceError: (WebResourceError err) {
                Scaffold.of(context)
                  .showSnackBar(
                    SnackBar(content: Text('Houve um erro ao carregar a página. Tente novamente.'),)
                  );
                Navigator.of(context).pop();
              },

              onWebViewCreated: (WebViewController controller) {
                _controller.complete(controller);
              },
            );
          }
        ),
      ),
    );
  }
}