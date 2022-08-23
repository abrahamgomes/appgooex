import 'package:gooex_mobile/src/models/usuario.dart';
import 'package:gooex_mobile/src/services/usuario_service.dart';

class UsuarioStore {
  final usuarioService = UsuarioService();

  Future<String> criarConta(Usuario usuario) =>
      usuarioService.registrarUsuario(usuario);

  Future<dynamic> criarTokenFCM(String tokenWeb, String tokenMob) =>
      usuarioService.criarTokenFCM(tokenWeb, tokenMob);

  Future<dynamic> atualizarTokenFCM(String tokenMob) =>
      usuarioService.atualizarTokenFCM(tokenMob);
}
