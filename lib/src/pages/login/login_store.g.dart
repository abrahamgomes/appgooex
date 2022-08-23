// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginStore on _LoginStore, Store {
  final _$usuarioAtom = Atom(name: '_LoginStore.usuario');

  @override
  Usuario get usuario {
    _$usuarioAtom.context.enforceReadPolicy(_$usuarioAtom);
    _$usuarioAtom.reportObserved();
    return super.usuario;
  }

  @override
  set usuario(Usuario value) {
    _$usuarioAtom.context.conditionallyRunInAction(() {
      super.usuario = value;
      _$usuarioAtom.reportChanged();
    }, _$usuarioAtom, name: '${_$usuarioAtom.name}_set');
  }

  final _$canToggleAtom = Atom(name: '_LoginStore.canToggle');

  @override
  bool get canToggle {
    _$canToggleAtom.context.enforceReadPolicy(_$canToggleAtom);
    _$canToggleAtom.reportObserved();
    return super.canToggle;
  }

  @override
  set canToggle(bool value) {
    _$canToggleAtom.context.conditionallyRunInAction(() {
      super.canToggle = value;
      _$canToggleAtom.reportChanged();
    }, _$canToggleAtom, name: '${_$canToggleAtom.name}_set');
  }

  final _$drawerToggleOpenAtom = Atom(name: '_LoginStore.drawerToggleOpen');

  @override
  bool get drawerToggleOpen {
    _$drawerToggleOpenAtom.context.enforceReadPolicy(_$drawerToggleOpenAtom);
    _$drawerToggleOpenAtom.reportObserved();
    return super.drawerToggleOpen;
  }

  @override
  set drawerToggleOpen(bool value) {
    _$drawerToggleOpenAtom.context.conditionallyRunInAction(() {
      super.drawerToggleOpen = value;
      _$drawerToggleOpenAtom.reportChanged();
    }, _$drawerToggleOpenAtom, name: '${_$drawerToggleOpenAtom.name}_set');
  }

  final _$isLogadoAtom = Atom(name: '_LoginStore.isLogado');

  @override
  bool get isLogado {
    _$isLogadoAtom.context.enforceReadPolicy(_$isLogadoAtom);
    _$isLogadoAtom.reportObserved();
    return super.isLogado;
  }

  @override
  set isLogado(bool value) {
    _$isLogadoAtom.context.conditionallyRunInAction(() {
      super.isLogado = value;
      _$isLogadoAtom.reportChanged();
    }, _$isLogadoAtom, name: '${_$isLogadoAtom.name}_set');
  }

  final _$loggedAsAtom = Atom(name: '_LoginStore.loggedAs');

  @override
  LoginType get loggedAs {
    _$loggedAsAtom.context.enforceReadPolicy(_$loggedAsAtom);
    _$loggedAsAtom.reportObserved();
    return super.loggedAs;
  }

  @override
  set loggedAs(LoginType value) {
    _$loggedAsAtom.context.conditionallyRunInAction(() {
      super.loggedAs = value;
      _$loggedAsAtom.reportChanged();
    }, _$loggedAsAtom, name: '${_$loggedAsAtom.name}_set');
  }

  final _$confirmacaoDesembarqueAtom =
      Atom(name: '_LoginStore.confirmacaoDesembarque');

  @override
  bool get confirmacaoDesembarque {
    _$confirmacaoDesembarqueAtom.context
        .enforceReadPolicy(_$confirmacaoDesembarqueAtom);
    _$confirmacaoDesembarqueAtom.reportObserved();
    return super.confirmacaoDesembarque;
  }

  @override
  set confirmacaoDesembarque(bool value) {
    _$confirmacaoDesembarqueAtom.context.conditionallyRunInAction(() {
      super.confirmacaoDesembarque = value;
      _$confirmacaoDesembarqueAtom.reportChanged();
    }, _$confirmacaoDesembarqueAtom,
        name: '${_$confirmacaoDesembarqueAtom.name}_set');
  }

  final _$doLoginAsyncAction = AsyncAction('doLogin');

  @override
  Future<void> doLogin(String email, dynamic password) {
    return _$doLoginAsyncAction.run(() => super.doLogin(email, password));
  }

  final _$_LoginStoreActionController = ActionController(name: '_LoginStore');

  @override
  void setLoginType(LoginType type) {
    final _$actionInfo = _$_LoginStoreActionController.startAction();
    try {
      return super.setLoginType(type);
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCanToggle(bool canToggle) {
    final _$actionInfo = _$_LoginStoreActionController.startAction();
    try {
      return super.setCanToggle(canToggle);
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDrawerToggle(bool v) {
    final _$actionInfo = _$_LoginStoreActionController.startAction();
    try {
      return super.setDrawerToggle(v);
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUsuario(Usuario usuario) {
    final _$actionInfo = _$_LoginStoreActionController.startAction();
    try {
      return super.setUsuario(usuario);
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void doLogout() {
    final _$actionInfo = _$_LoginStoreActionController.startAction();
    try {
      return super.doLogout();
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setConfirmacaoDesembarque(bool v) {
    final _$actionInfo = _$_LoginStoreActionController.startAction();
    try {
      return super.setConfirmacaoDesembarque(v);
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'usuario: ${usuario.toString()},canToggle: ${canToggle.toString()},drawerToggleOpen: ${drawerToggleOpen.toString()},isLogado: ${isLogado.toString()},loggedAs: ${loggedAs.toString()},confirmacaoDesembarque: ${confirmacaoDesembarque.toString()}';
    return '{$string}';
  }
}
