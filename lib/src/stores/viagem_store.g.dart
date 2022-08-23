// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'viagem_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ViagemStore on _ViagemStore, Store {
  final _$mostrarTudoAtom = Atom(name: '_ViagemStore.mostrarTudo');

  @override
  bool get mostrarTudo {
    _$mostrarTudoAtom.context.enforceReadPolicy(_$mostrarTudoAtom);
    _$mostrarTudoAtom.reportObserved();
    return super.mostrarTudo;
  }

  @override
  set mostrarTudo(bool value) {
    _$mostrarTudoAtom.context.conditionallyRunInAction(() {
      super.mostrarTudo = value;
      _$mostrarTudoAtom.reportChanged();
    }, _$mostrarTudoAtom, name: '${_$mostrarTudoAtom.name}_set');
  }

  final _$dataPartidaAtom = Atom(name: '_ViagemStore.dataPartida');

  @override
  DateTime get dataPartida {
    _$dataPartidaAtom.context.enforceReadPolicy(_$dataPartidaAtom);
    _$dataPartidaAtom.reportObserved();
    return super.dataPartida;
  }

  @override
  set dataPartida(DateTime value) {
    _$dataPartidaAtom.context.conditionallyRunInAction(() {
      super.dataPartida = value;
      _$dataPartidaAtom.reportChanged();
    }, _$dataPartidaAtom, name: '${_$dataPartidaAtom.name}_set');
  }

  final _$dataChegadaAtom = Atom(name: '_ViagemStore.dataChegada');

  @override
  DateTime get dataChegada {
    _$dataChegadaAtom.context.enforceReadPolicy(_$dataChegadaAtom);
    _$dataChegadaAtom.reportObserved();
    return super.dataChegada;
  }

  @override
  set dataChegada(DateTime value) {
    _$dataChegadaAtom.context.conditionallyRunInAction(() {
      super.dataChegada = value;
      _$dataChegadaAtom.reportChanged();
    }, _$dataChegadaAtom, name: '${_$dataChegadaAtom.name}_set');
  }

  final _$horarioPartidaAtom = Atom(name: '_ViagemStore.horarioPartida');

  @override
  String get horarioPartida {
    _$horarioPartidaAtom.context.enforceReadPolicy(_$horarioPartidaAtom);
    _$horarioPartidaAtom.reportObserved();
    return super.horarioPartida;
  }

  @override
  set horarioPartida(String value) {
    _$horarioPartidaAtom.context.conditionallyRunInAction(() {
      super.horarioPartida = value;
      _$horarioPartidaAtom.reportChanged();
    }, _$horarioPartidaAtom, name: '${_$horarioPartidaAtom.name}_set');
  }

  final _$horarioChegadaAtom = Atom(name: '_ViagemStore.horarioChegada');

  @override
  String get horarioChegada {
    _$horarioChegadaAtom.context.enforceReadPolicy(_$horarioChegadaAtom);
    _$horarioChegadaAtom.reportObserved();
    return super.horarioChegada;
  }

  @override
  set horarioChegada(String value) {
    _$horarioChegadaAtom.context.conditionallyRunInAction(() {
      super.horarioChegada = value;
      _$horarioChegadaAtom.reportChanged();
    }, _$horarioChegadaAtom, name: '${_$horarioChegadaAtom.name}_set');
  }

  final _$aeroportoAtom = Atom(name: '_ViagemStore.aeroporto');

  @override
  String get aeroporto {
    _$aeroportoAtom.context.enforceReadPolicy(_$aeroportoAtom);
    _$aeroportoAtom.reportObserved();
    return super.aeroporto;
  }

  @override
  set aeroporto(String value) {
    _$aeroportoAtom.context.conditionallyRunInAction(() {
      super.aeroporto = value;
      _$aeroportoAtom.reportChanged();
    }, _$aeroportoAtom, name: '${_$aeroportoAtom.name}_set');
  }

  final _$verPendentesAtom = Atom(name: '_ViagemStore.verPendentes');

  @override
  bool get verPendentes {
    _$verPendentesAtom.context.enforceReadPolicy(_$verPendentesAtom);
    _$verPendentesAtom.reportObserved();
    return super.verPendentes;
  }

  @override
  set verPendentes(bool value) {
    _$verPendentesAtom.context.conditionallyRunInAction(() {
      super.verPendentes = value;
      _$verPendentesAtom.reportChanged();
    }, _$verPendentesAtom, name: '${_$verPendentesAtom.name}_set');
  }

  final _$viagensAtom = Atom(name: '_ViagemStore.viagens');

  @override
  ObservableFuture<List<Viagem>> get viagens {
    _$viagensAtom.context.enforceReadPolicy(_$viagensAtom);
    _$viagensAtom.reportObserved();
    return super.viagens;
  }

  @override
  set viagens(ObservableFuture<List<Viagem>> value) {
    _$viagensAtom.context.conditionallyRunInAction(() {
      super.viagens = value;
      _$viagensAtom.reportChanged();
    }, _$viagensAtom, name: '${_$viagensAtom.name}_set');
  }

  final _$pedidosAtom = Atom(name: '_ViagemStore.pedidos');

  @override
  ObservableFuture<List<Pedido>> get pedidos {
    _$pedidosAtom.context.enforceReadPolicy(_$pedidosAtom);
    _$pedidosAtom.reportObserved();
    return super.pedidos;
  }

  @override
  set pedidos(ObservableFuture<List<Pedido>> value) {
    _$pedidosAtom.context.conditionallyRunInAction(() {
      super.pedidos = value;
      _$pedidosAtom.reportChanged();
    }, _$pedidosAtom, name: '${_$pedidosAtom.name}_set');
  }

  final _$aeroportosAtom = Atom(name: '_ViagemStore.aeroportos');

  @override
  ObservableFuture<List<Aeroporto>> get aeroportos {
    _$aeroportosAtom.context.enforceReadPolicy(_$aeroportosAtom);
    _$aeroportosAtom.reportObserved();
    return super.aeroportos;
  }

  @override
  set aeroportos(ObservableFuture<List<Aeroporto>> value) {
    _$aeroportosAtom.context.conditionallyRunInAction(() {
      super.aeroportos = value;
      _$aeroportosAtom.reportChanged();
    }, _$aeroportosAtom, name: '${_$aeroportosAtom.name}_set');
  }

  final _$listarPedidosAsyncAction = AsyncAction('listarPedidos');

  @override
  Future<dynamic> listarPedidos(String viagemId) {
    return _$listarPedidosAsyncAction.run(() => super.listarPedidos(viagemId));
  }

  final _$listarAeroportosAsyncAction = AsyncAction('listarAeroportos');

  @override
  Future<dynamic> listarAeroportos() {
    return _$listarAeroportosAsyncAction.run(() => super.listarAeroportos());
  }

  final _$_ViagemStoreActionController = ActionController(name: '_ViagemStore');

  @override
  void setHorarioPartida(String horario) {
    final _$actionInfo = _$_ViagemStoreActionController.startAction();
    try {
      return super.setHorarioPartida(horario);
    } finally {
      _$_ViagemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void visualizarPendentes(bool v) {
    final _$actionInfo = _$_ViagemStoreActionController.startAction();
    try {
      return super.visualizarPendentes(v);
    } finally {
      _$_ViagemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setHorarioChegada(String horario) {
    final _$actionInfo = _$_ViagemStoreActionController.startAction();
    try {
      return super.setHorarioChegada(horario);
    } finally {
      _$_ViagemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDataPartida(DateTime data) {
    final _$actionInfo = _$_ViagemStoreActionController.startAction();
    try {
      return super.setDataPartida(data);
    } finally {
      _$_ViagemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDataChegada(DateTime data) {
    final _$actionInfo = _$_ViagemStoreActionController.startAction();
    try {
      return super.setDataChegada(data);
    } finally {
      _$_ViagemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAeroporto(String aeroporto) {
    final _$actionInfo = _$_ViagemStoreActionController.startAction();
    try {
      return super.setAeroporto(aeroporto);
    } finally {
      _$_ViagemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMostrarTudo(bool mostrarTudo) {
    final _$actionInfo = _$_ViagemStoreActionController.startAction();
    try {
      return super.setMostrarTudo(mostrarTudo);
    } finally {
      _$_ViagemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> aceitarPedido(
      String viagemUUID, String ordemServicoUUID, bool confirma) {
    final _$actionInfo = _$_ViagemStoreActionController.startAction();
    try {
      return super.aceitarPedido(viagemUUID, ordemServicoUUID, confirma);
    } finally {
      _$_ViagemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<dynamic> listarViagens() {
    final _$actionInfo = _$_ViagemStoreActionController.startAction();
    try {
      return super.listarViagens();
    } finally {
      _$_ViagemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'mostrarTudo: ${mostrarTudo.toString()},dataPartida: ${dataPartida.toString()},dataChegada: ${dataChegada.toString()},horarioPartida: ${horarioPartida.toString()},horarioChegada: ${horarioChegada.toString()},aeroporto: ${aeroporto.toString()},verPendentes: ${verPendentes.toString()},viagens: ${viagens.toString()},pedidos: ${pedidos.toString()},aeroportos: ${aeroportos.toString()}';
    return '{$string}';
  }
}
