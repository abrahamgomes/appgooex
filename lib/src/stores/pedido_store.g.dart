// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pedido_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PedidoStore on _PedidoStore, Store {
  final _$statusAplicadoAtom = Atom(name: '_PedidoStore.statusAplicado');

  @override
  int get statusAplicado {
    _$statusAplicadoAtom.context.enforceReadPolicy(_$statusAplicadoAtom);
    _$statusAplicadoAtom.reportObserved();
    return super.statusAplicado;
  }

  @override
  set statusAplicado(int value) {
    _$statusAplicadoAtom.context.conditionallyRunInAction(() {
      super.statusAplicado = value;
      _$statusAplicadoAtom.reportChanged();
    }, _$statusAplicadoAtom, name: '${_$statusAplicadoAtom.name}_set');
  }

  final _$pedidosClienteAtom = Atom(name: '_PedidoStore.pedidosCliente');

  @override
  ObservableFuture<List<Pedido>> get pedidosCliente {
    _$pedidosClienteAtom.context.enforceReadPolicy(_$pedidosClienteAtom);
    _$pedidosClienteAtom.reportObserved();
    return super.pedidosCliente;
  }

  @override
  set pedidosCliente(ObservableFuture<List<Pedido>> value) {
    _$pedidosClienteAtom.context.conditionallyRunInAction(() {
      super.pedidosCliente = value;
      _$pedidosClienteAtom.reportChanged();
    }, _$pedidosClienteAtom, name: '${_$pedidosClienteAtom.name}_set');
  }

  final _$pedidosTransportadorAtom =
      Atom(name: '_PedidoStore.pedidosTransportador');

  @override
  ObservableFuture<List<Pedido>> get pedidosTransportador {
    _$pedidosTransportadorAtom.context
        .enforceReadPolicy(_$pedidosTransportadorAtom);
    _$pedidosTransportadorAtom.reportObserved();
    return super.pedidosTransportador;
  }

  @override
  set pedidosTransportador(ObservableFuture<List<Pedido>> value) {
    _$pedidosTransportadorAtom.context.conditionallyRunInAction(() {
      super.pedidosTransportador = value;
      _$pedidosTransportadorAtom.reportChanged();
    }, _$pedidosTransportadorAtom,
        name: '${_$pedidosTransportadorAtom.name}_set');
  }

  final _$_PedidoStoreActionController = ActionController(name: '_PedidoStore');

  @override
  Future<dynamic> listarPedidosTransportador({int status}) {
    final _$actionInfo = _$_PedidoStoreActionController.startAction();
    try {
      return super.listarPedidosTransportador(status: status);
    } finally {
      _$_PedidoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<dynamic> listarPedidosCliente({int status}) {
    final _$actionInfo = _$_PedidoStoreActionController.startAction();
    try {
      return super.listarPedidosCliente(status: status);
    } finally {
      _$_PedidoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStatusAplicado(int status) {
    final _$actionInfo = _$_PedidoStoreActionController.startAction();
    try {
      return super.setStatusAplicado(status);
    } finally {
      _$_PedidoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'statusAplicado: ${statusAplicado.toString()},pedidosCliente: ${pedidosCliente.toString()},pedidosTransportador: ${pedidosTransportador.toString()}';
    return '{$string}';
  }
}
