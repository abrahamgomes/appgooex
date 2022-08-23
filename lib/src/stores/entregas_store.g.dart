// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entregas_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$EntregaStore on _EntregaStore, Store {
  final _$entregasDisponiveisAtom =
      Atom(name: '_EntregaStore.entregasDisponiveis');

  @override
  ObservableFuture<List<OrdemServicoEntregador>> get entregasDisponiveis {
    _$entregasDisponiveisAtom.context
        .enforceReadPolicy(_$entregasDisponiveisAtom);
    _$entregasDisponiveisAtom.reportObserved();
    return super.entregasDisponiveis;
  }

  @override
  set entregasDisponiveis(
      ObservableFuture<List<OrdemServicoEntregador>> value) {
    _$entregasDisponiveisAtom.context.conditionallyRunInAction(() {
      super.entregasDisponiveis = value;
      _$entregasDisponiveisAtom.reportChanged();
    }, _$entregasDisponiveisAtom,
        name: '${_$entregasDisponiveisAtom.name}_set');
  }

  final _$minhasEntregasAtom = Atom(name: '_EntregaStore.minhasEntregas');

  @override
  ObservableFuture<List<OrdemServicoEntregador>> get minhasEntregas {
    _$minhasEntregasAtom.context.enforceReadPolicy(_$minhasEntregasAtom);
    _$minhasEntregasAtom.reportObserved();
    return super.minhasEntregas;
  }

  @override
  set minhasEntregas(ObservableFuture<List<OrdemServicoEntregador>> value) {
    _$minhasEntregasAtom.context.conditionallyRunInAction(() {
      super.minhasEntregas = value;
      _$minhasEntregasAtom.reportChanged();
    }, _$minhasEntregasAtom, name: '${_$minhasEntregasAtom.name}_set');
  }

  final _$shippingImagesAtom = Atom(name: '_EntregaStore.shippingImages');

  @override
  ObservableFuture<List<ImageUpload>> get shippingImages {
    _$shippingImagesAtom.context.enforceReadPolicy(_$shippingImagesAtom);
    _$shippingImagesAtom.reportObserved();
    return super.shippingImages;
  }

  @override
  set shippingImages(ObservableFuture<List<ImageUpload>> value) {
    _$shippingImagesAtom.context.conditionallyRunInAction(() {
      super.shippingImages = value;
      _$shippingImagesAtom.reportChanged();
    }, _$shippingImagesAtom, name: '${_$shippingImagesAtom.name}_set');
  }

  final _$progressoUploadTextoAtom =
      Atom(name: '_EntregaStore.progressoUploadTexto');

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
      Atom(name: '_EntregaStore.progressoUploadIsWorking');

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

  final _$sendPictureAsyncAction = AsyncAction('sendPicture');

  @override
  Future<void> sendPicture(String entregaUUID, String pathImagem) {
    return _$sendPictureAsyncAction
        .run(() => super.sendPicture(entregaUUID, pathImagem));
  }

  final _$_EntregaStoreActionController =
      ActionController(name: '_EntregaStore');

  @override
  void setProgressoUploadTexto(String texto) {
    final _$actionInfo = _$_EntregaStoreActionController.startAction();
    try {
      return super.setProgressoUploadTexto(texto);
    } finally {
      _$_EntregaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setWorkingUpload(bool v) {
    final _$actionInfo = _$_EntregaStoreActionController.startAction();
    try {
      return super.setWorkingUpload(v);
    } finally {
      _$_EntregaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> listarEntregasDisponiveis() {
    final _$actionInfo = _$_EntregaStoreActionController.startAction();
    try {
      return super.listarEntregasDisponiveis();
    } finally {
      _$_EntregaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> listarMinhasEntregas() {
    final _$actionInfo = _$_EntregaStoreActionController.startAction();
    try {
      return super.listarMinhasEntregas();
    } finally {
      _$_EntregaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'entregasDisponiveis: ${entregasDisponiveis.toString()},minhasEntregas: ${minhasEntregas.toString()},shippingImages: ${shippingImages.toString()},progressoUploadTexto: ${progressoUploadTexto.toString()},progressoUploadIsWorking: ${progressoUploadIsWorking.toString()}';
    return '{$string}';
  }
}
