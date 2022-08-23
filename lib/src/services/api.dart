import 'dart:convert';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:http/http.dart' as http;

class Api {

// static final String baseUrl = 'https://gooex-django.herokuapp.com/api/1.0'; // api teste homologação
  // static final String baseUrl = 'https://gooex.com.br/api/1.0'; // api produção
  static final String baseUrl = 'https://app.gooex.com.br/api/1.0'; // nova urlbase api
   
  
  
  
  static Future<http.Response> post(String url, dynamic body,
      {Map<String, String> headers}) {
    var requestHeaders = new Map<String, String>();
    if (headers != null) {
      requestHeaders = headers;
    }
    requestHeaders['Content-Type'] = 'application/json;charset=utf-8';
    requestHeaders['Connection'] = 'keep-alive';
    requestHeaders['Cache-Control'] = 'no-cache';
    requestHeaders['Accept'] = '*/*';

    if (loginStore.usuario != null && loginStore.usuario.token.isNotEmpty) {
      requestHeaders['Authorization'] = 'Token ${loginStore.usuario.token}';
    }

    print('\n**** START REQUEST ****');
    print('URL: $baseUrl$url');
    print('METHOD: POST');
    print('Body: $body');
    print('Headers : $requestHeaders');
    print('**** END OF REQUEST **** \n');

    print('RESPONSE: ${jsonEncode(body)}');
    

    return http.post(Uri.parse('$baseUrl$url'),
        body: jsonEncode(body),
        headers: requestHeaders); //.timeout(Duration(minutes: 1));
  }

  static Future<http.Response> get(String url, {Map<String, String> headers}) {
   

    if (loginStore.usuario != null && loginStore.usuario.token.isNotEmpty) {
      if (headers == null) {
        headers = {};
      }
      headers['Authorization'] = 'Token ${loginStore.usuario.token}';
      headers['Content-Type'] = 'application/json;charset=utf-8;';
    }

     print('\n**** START REQUEST ****');
    print('URL: $baseUrl$url');
    print('Headers : $headers');
    print('**** END OF REQUEST **** \n');

    return http.get(Uri.parse('$baseUrl$url'), headers: headers);
  }

  static Future<http.Response> put(String url, dynamic body,
      {Map<String, String> headers}) {
    var requestHeaders = new Map<String, String>();
    if (headers != null) {
      requestHeaders = headers;
    }
    requestHeaders['Content-Type'] = 'application/json;charset=utf-8';
    requestHeaders['Connection'] = 'keep-alive';
    requestHeaders['Cache-Control'] = 'no-cache';
    requestHeaders['Accept'] = '*/*';

    if (loginStore.usuario != null && loginStore.usuario.token.isNotEmpty) {
      requestHeaders['Authorization'] = 'Token ${loginStore.usuario.token}';
    }

    // print('\n**** START REQUEST ****');
    // print('URL: $baseUrl$url');
    // print('Body: $body');
    // print('Headers : $requestHeaders');
    // print('**** END OF REQUEST **** \n');

    print('\n**** START REQUEST ****');
    print('URL: $baseUrl$url');
    print('METHOD: POST');
    print('Body: $body');
    print('Headers : $requestHeaders');
    print('**** END OF REQUEST **** \n');

    print('RESPONSE: ${jsonEncode(body)}');

    return http.put(Uri.parse('$baseUrl$url'),
        body: jsonEncode(body),
        headers: requestHeaders); //.timeout(Duration(minutes: 1));
  }

  static Future<http.Response> delete(String url) {
    return http.get(Uri.parse('$baseUrl$url'));
  }
}
