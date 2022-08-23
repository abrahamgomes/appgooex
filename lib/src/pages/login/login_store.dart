import 'package:gooex_mobile/src/models/usuario.dart';
import 'package:gooex_mobile/src/services/usuario_service.dart';
import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

enum LoginType {
  ENTREGADOR,
  CLIENTE,
  TRANSPORTADOR
}

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  final _service = UsuarioService();

  @observable
  Usuario usuario;

  @observable
  bool canToggle = false;

  @observable
  bool drawerToggleOpen = false;

  @observable
  bool isLogado = false;

  @observable
  LoginType loggedAs = LoginType.ENTREGADOR;

  @observable
  bool confirmacaoDesembarque = false;

  @action
  Future<void> doLogin(String email, password) async {
    usuario = await _service.login(email, password);
    canToggle = usuario.transportador || usuario.entregador;
  }

  @action
  void setLoginType(LoginType type) {
    loggedAs = type;
  }

  @action
  void setCanToggle(bool canToggle) {
    this.canToggle = canToggle;
  }

  @action
  void setDrawerToggle(bool v) => drawerToggleOpen = v;

  @action
  void setUsuario(Usuario usuario) {
    this.usuario = usuario;
  }

  @action
  void doLogout() {
    usuario = null;
    isLogado = false;
  }

  @action
  void setConfirmacaoDesembarque(bool v) => confirmacaoDesembarque = v;
}

final loginStore = LoginStore();