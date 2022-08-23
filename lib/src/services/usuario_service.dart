import 'dart:async';
import 'dart:convert';

import 'package:gooex_mobile/src/models/usuario.dart';
import 'package:gooex_mobile/src/services/api.dart';
import 'package:gooex_mobile/src/services/exceptions/api_response_exception.dart';

class UsuarioService {


  Future criarTokenFCM(String tokenWeb, String tokenMob) async {
    final response = await Api.post('/usuario/gravar_token_front', {
      'token_web': tokenWeb,
      'token_mob': tokenMob
    });

    if(response.statusCode != 200 && response.statusCode != 201) {
      throw new ApiResponseException('Não foi possível criar os tokens do FCM');
    }
  }

  Future atualizarTokenFCM(String tokenMob)  async {
    
    // if(tokenMob != null && tokenMob.isNotEmpty) postData['token_mob'] = token
    final response = await Api.put('/usuario/atualizar_token_front', {
      'token_mob': tokenMob
    });

    print('Retorno da atualização do token ${json.decode(response.body)}');

    if(response.statusCode != 200 && response.statusCode != 201) {
      throw new ApiResponseException('Não foi possível criar os tokens do FCM');
    }
  }

  Future<String> registrarUsuario(Usuario usuario) async {
    final response = await Api.post('/usuario/', usuario.toJsonPOST());

    if(response.statusCode != 200 && response.statusCode != 201) {
      // TODO: Padronizar retorno desse endpoint
      var data = json.decode(utf8.decode(response.bodyBytes));
      // var data = json.decode(utf8.decode(response.bodyBytes));
      throw new ApiResponseException('Falha ao criar a conta. Certifique-se que preencheu o formulário corretamente', payload: data);
    }

    return json.decode(response.body);
  }


  Future<Usuario> login(String email, String password) async {
    Usuario usuario = Usuario();
    try {
      var responseTokenAuth = Api.post('/token-auth/', {
        'email': email,
        'username': email,
        'password': password
      });
      var res = await responseTokenAuth;
    // https://stackoverflow.com/questions/51368663/flutter-fetched-japanese-character-from-server-decoded-wrong
      print(await res.body);

      if(res.statusCode == 200) {
        // var body = jsonDecode(responseTokenAuth.body);
        var body = json.decode(utf8.decode(res.bodyBytes));
        usuario.id = body['user_id'];
        usuario.token = body['token'];
        usuario.email = body['email'];

        // whoami
        var responseWhoAmI = await Api.get('/usuario', headers: {
          'Authorization': 'Token ${usuario.token}'
        });

        if(responseWhoAmI.statusCode == 200) {
          // body = jsonDecode(responseWhoAmI.body);
          body = json.decode(utf8.decode(responseWhoAmI.bodyBytes));

          usuario.username = body['username'];
          usuario.cpf = body['cpf'];
          usuario.transportador = body['transportador'];
          usuario.entregador = body['entregador'];
          usuario.empresa = body['empresa'];
          usuario.firstName = body['first_name'];
          usuario.lastName = body['last_name'];
          //usuario.dataNasc = body['dataNasc'];
        }
      }else {
        throw new Exception(['Falha no login']);
      }

    }catch(e) {
      print(e);
      throw new Exception(['Falha no login']);
    }
    return usuario;
  }
}