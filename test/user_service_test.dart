import 'package:flutter_test/flutter_test.dart';
import 'package:gooex_mobile/src/models/ordem_servico.dart';
import 'package:gooex_mobile/src/models/usuario.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/services/usuario_service.dart';


void main() {
  var usuarioService = UsuarioService();
    // expectE
  
  test('registrar usuário', () async { 
    final retorno = await usuarioService.registrarUsuario(Usuario(
      firstName: 'O tal do',
      lastName: 'cliente2',
      cpf: '64374367004',
      username: 'cliente2@gmail.com',
      email: 'cliente2@gmail.com',
      password: '123456',
      transportador: false
    ));

    await usuarioService.registrarUsuario(Usuario(
      firstName: 'O tal do',
      lastName: 'transportador2',
      cpf: '92748944062',
      username: 'transportador2@gmail.com',
      email: 'transportador2@gmail.com',
      password: '123456',
      transportador: true
    ));

    expect(retorno, 'Usuario criado com sucesso !');
  });


  test('create FCM Tokens', () async {
    await loginStore.doLogin('transportador2@gmail.com', '123456');
    await usuarioService.criarTokenFCM('unset', 'my-token-mobile');
    expect(true, true);
  });


  test('update FCM Tokens', () async {
    await loginStore.doLogin('transportador2@gmail.com', '123456');
    await usuarioService.atualizarTokenFCM('changed');
    expect(true, true);
  });

}