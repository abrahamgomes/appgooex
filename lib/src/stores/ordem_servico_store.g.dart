// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ordem_servico_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OrdemServicoStore on _OrdemServicoStore, Store {
  final _$statusAplicadoAtom = Atom(name: '_OrdemServicoStore.statusAplicado');

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

  final _$ordensServicoAtom = Atom(name: '_OrdemServicoStore.ordensServico');

  @override
  ObservableFuture<List<OrdemServico>> get ordensServico {
    _$ordensServicoAtom.context.enforceReadPolicy(_$ordensServicoAtom);
    _$ordensServicoAtom.reportObserved();
    return super.ordensServico;
  }

  @override
  set ordensServico(ObservableFuture<List<OrdemServico>> value) {
    _$ordensServicoAtom.context.conditionallyRunInAction(() {
      super.ordensServico = value;
      _$ordensServicoAtom.reportChanged();
    }, _$ordensServicoAtom, name: '${_$ordensServicoAtom.name}_set');
  }

  final _$imagensPedidoAtom = Atom(name: '_OrdemServicoStore.imagensPedido');

  @override
  ObservableFuture<List<ImageUpload>> get imagensPedido {
    _$imagensPedidoAtom.context.enforceReadPolicy(_$imagensPedidoAtom);
    _$imagensPedidoAtom.reportObserved();
    return super.imagensPedido;
  }

  @override
  set imagensPedido(ObservableFuture<List<ImageUpload>> value) {
    _$imagensPedidoAtom.context.conditionallyRunInAction(() {
      super.imagensPedido = value;
      _$imagensPedidoAtom.reportChanged();
    }, _$imagensPedidoAtom, name: '${_$imagensPedidoAtom.name}_set');
  }

  final _$progressoUploadTextoAtom =
      Atom(name: '_OrdemServicoStore.progressoUploadTexto');

  @override
  String get progressoUploadTexto {
    _$progressoUploadTextoAtom.context
        .enforceReadPolicy(_$progressoUploadTextoAtom);
    _$progressoUploadTextoAtom.reportObserved();
    return super.progressoUploadTexto;
  }

  @override
  set progressoUploadTexto(String value) {
    _$progressoUploadTextoAtom.context.conditionallyRunInAction(() {
      super.progressoUploadTexto = value;
      _$progressoUploadTextoAtom.reportChanged();
    }, _$progressoUploadTextoAtom,
        name: '${_$progressoUploadTextoAtom.name}_set');
  }

  final _$progressoUploadIsWorkingAtom =
      Atom(name: '_OrdemServicoStore.progressoUploadIsWorking');

  @override
  bool get progressoUploadIsWorking {
    _$progressoUploadIsWorkingAtom.context
        .enforceReadPolicy(_$progressoUploadIsWorkingAtom);
    _$progressoUploadIsWorkingAtom.reportObserved();
    return super.progressoUploadIsWorking;
  }

  @override
  set progressoUploadIsWorking(bool value) {
    _$progressoUploadIsWorkingAtom.context.conditionallyRunInAction(() {
      super.progressoUploadIsWorking = value;
      _$progressoUploadIsWorkingAtom.reportChanged();
    }, _$progressoUploadIsWorkingAtom,
        name: '${_$progressoUploadIsWorkingAtom.name}_set');
  }

  final _$transportadoresDisponiveisAtom =
      Atom(name: '_OrdemServicoStore.transportadoresDisponiveis');

  @override
  ObservableFuture<List<Viagem>> get transportadoresDisponiveis {
    _$transportadoresDisponiveisAtom.context
        .enforceReadPolicy(_$transportadoresDisponiveisAtom);
    _$transportadoresDisponiveisAtom.reportObserved();
    return super.transportadoresDisponiveis;
  }

  @override
  set transportadoresDisponiveis(ObservableFuture<List<Viagem>> value) {
    _$transportadoresDisponiveisAtom.context.conditionallyRunInAction(() {
      super.transportadoresDisponiveis = value;
      _$transportadoresDisponiveisAtom.reportChanged();
    }, _$transportadoresDisponiveisAtom,
        name: '${_$transportadoresDisponiveisAtom.name}_set');
  }

  final _$ordemPagamentoAtom = Atom(name: '_OrdemServicoStore.ordemPagamento');

  @override
  ObservableFuture<OrdemPagamento> get ordemPagamento {
    _$ordemPagamentoAtom.context.enforceReadPolicy(_$ordemPagamentoAtom);
    _$ordemPagamentoAtom.reportObserved();
    return super.ordemPagamento;
  }

  @override
  set ordemPagamento(ObservableFuture<OrdemPagamento> value) {
    _$ordemPagamentoAtom.context.conditionallyRunInAction(() {
      super.ordemPagamento = value;
      _$ordemPagamentoAtom.reportChanged();
    }, _$ordemPagamentoAtom, name: '${_$ordemPagamentoAtom.name}_set');
  }

  final _$enderecoTransportadorAtom =
      Atom(name: '_OrdemServicoStore.enderecoTransportador');

  @override
  ObservableFuture<EnderecoTransportador> get enderecoTransportador {
    _$enderecoTransportadorAtom.context
        .enforceReadPolicy(_$enderecoTransportadorAtom);
    _$enderecoTransportadorAtom.reportObserved();
    return super.enderecoTransportador;
  }

  @override
  set enderecoTransportador(ObservableFuture<EnderecoTransportador> value) {
    _$enderecoTransportadorAtom.context.conditionallyRunInAction(() {
      super.enderecoTransportador = value;
      _$enderecoTransportadorAtom.reportChanged();
    }, _$enderecoTransportadorAtom,
        name: '${_$enderecoTransportadorAtom.name}_set');
  }

  final _$_OrdemServicoStoreActionController =
      ActionController(name: '_OrdemServicoStore');

  @override
  Future<dynamic> buscarEndereco(String ordemServicoUUID) {
    final _$actionInfo = _$_OrdemServicoStoreActionController.startAction();
    try {
      return super.buscarEndereco(ordemServicoUUID);
    } finally {
      _$_OrdemServicoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStatusAplicaco(int status) {
    final _$actionInfo = _$_OrdemServicoStoreActionController.startAction();
    try {
      return super.setStatusAplicaco(status);
    } finally {
      _$_OrdemServicoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProgressoUploadTexto(String texto) {
    final _$actionInfo = _$_OrdemServicoStoreActionController.startAction();
    try {
      return super.setProgressoUploadTexto(texto);
    } finally {
      _$_OrdemServicoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setWorkingUpload(bool v) {
    final _$actionInfo = _$_OrdemServicoStoreActionController.startAction();
    try {
      return super.setWorkingUpload(v);
    } finally {
      _$_OrdemServicoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<dynamic> listaOrdensServico({int status}) {
    final _$actionInfo = _$_OrdemServicoStoreActionController.startAction();
    try {
      return super.listaOrdensServico(status: status);
    } finally {
      _$_OrdemServicoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<dynamic> listarTransportadoresDisponiveis(String ordemServicoId) {
    final _$actionInfo = _$_OrdemServicoStoreActionController.startAction();
    try {
      return super.listarTransportadoresDisponiveis(ordemServicoId);
    } finally {
      _$_OrdemServicoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<dynamic> listarImagensPedido(String ordemServicoUUID) {
    final _$actionInfo = _$_OrdemServicoStoreActionController.startAction();
    try {
      return super.listarImagensPedido(ordemServicoUUID);
    } finally {
      _$_OrdemServicoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> sendPicture(String ordemServicoUUID, String pathImagem) {
    final _$actionInfo = _$_OrdemServicoStoreActionController.startAction();
    try {
      return super.sendPicture(ordemServicoUUID, pathImagem);
    } finally {
      _$_OrdemServicoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> obterOrdemPagamento(String ordemServicoUUID) {
    final _$actionInfo = _$_OrdemServicoStoreActionController.startAction();
    try {
      return super.obterOrdemPagamento(ordemServicoUUID);
    } finally {
      _$_OrdemServicoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addImageContainer() {
    final _$actionInfo = _$_OrdemServicoStoreActionController.startAction();
    try {
      return super.addImageContainer();
    } finally {
      _$_OrdemServicoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateImageContainer(int index, ImageUpload imageUpload) {
    final _$actionInfo = _$_OrdemServicoStoreActionController.startAction();
    try {
      return super.updateImageContainer(index, imageUpload);
    } finally {
      _$_OrdemServicoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'statusAplicado: ${statusAplicado.toString()},ordensServico: ${ordensServico.toString()},imagensPedido: ${imagensPedido.toString()},progressoUploadTexto: ${progressoUploadTexto.toString()},progressoUploadIsWorking: ${progressoUploadIsWorking.toString()},transportadoresDisponiveis: ${transportadoresDisponiveis.toString()},ordemPagamento: ${ordemPagamento.toString()},enderecoTransportador: ${enderecoTransportador.toString()}';
    return '{$string}';
  }
}
