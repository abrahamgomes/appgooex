import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewMercadoPago extends StatefulWidget {

  final String paymentUrl;
  final bool isSandbox;

  WebViewMercadoPago({this.paymentUrl, this.isSandbox});

  @override
  _WebViewMercadoPagoState createState() => _WebViewMercadoPagoState();
}

class _WebViewMercadoPagoState extends State<WebViewMercadoPago> {

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
      appBar: AppBar(
        title: Text('Mercado Pago'),
      ),

      body: Builder(
        builder: (BuildContext context) {
          return WebView(
            // initialUrl: 'https://flutter.dev',
            initialUrl: widget.paymentUrl,
            javascriptMode: JavascriptMode.unrestricted,
            userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36',
            debuggingEnabled: true,
            onPageFinished: (String value) async {
              
            },
            onPageStarted: (String val) {
              // UtilDialog.presentLoader(context);
            },
            onWebResourceError: (WebResourceError err) {
              Scaffold.of(context)
                .showSnackBar(
                  SnackBar(content: Text('Houve um erro ao carregar a página. Tente novamente.'),)
                );
              Navigator.of(context).pop();
            },

            navigationDelegate: (req) {
              // Workaraound para testes
              if(req.url.startsWith('https://apigeomk.com.br/api')) {
                String newUrl = req.url.replaceAll('apigeomk', 'apigooex.geomk');
                print('Workaraound\n\nFrom: ${req.url}\nTo: $newUrl');
                _controller.future.then((ctrl) => ctrl.loadUrl(newUrl));
                return NavigationDecision.prevent;
              }

              if(req.url.startsWith('https://gooex.com.br/payment/succes') || req.url.startsWith('https://gooex.com.br/payment/failure')) {
                Navigator.of(context).pop(req.url);
                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            },

            onWebViewCreated: (WebViewController controller) {
              _controller.complete(controller);
            },
          );
        }
      ),
    );
  }
}