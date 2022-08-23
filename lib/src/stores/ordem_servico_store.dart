import 'package:gooex_mobile/src/models/endereco_transportador.dart';
import 'package:gooex_mobile/src/models/image_upload.dart';
import 'package:gooex_mobile/src/models/ordem_pagamento.dart';
import 'package:gooex_mobile/src/models/ordem_servico.dart';
import 'package:gooex_mobile/src/models/viagem.dart';

import 'package:gooex_mobile/src/services/ordem_servico_service.dart';
import 'package:mobx/mobx.dart';

part 'ordem_servico_store.g.dart';


class OrdemServicoStore = _OrdemServicoStore with _$OrdemServicoStore;

abstract class _OrdemServicoStore with Store {

  final ordemServicoService = OrdemServicoService();

  @observable
  int statusAplicado;

  @observable
  ObservableFuture<List<OrdemServico>> ordensServico;

  @observable
  ObservableFuture<List<ImageUpload>> imagensPedido = ObservableFuture(Future.value([
    ImageUpload(),
    ImageUpload(),
    ImageUpload(),
  ]));

  @observable
  String progressoUploadTexto = 'Iniciando upload';

  @observable
  bool progressoUploadIsWorking = false;
  
  @observable
  ObservableFuture<List<Viagem>> transportadoresDisponiveis;

  @observable
  ObservableFuture<OrdemPagamento> ordemPagamento;

  @observable
  ObservableFuture<EnderecoTransportador> enderecoTransportador;


  @action
  Future buscarEndereco(String ordemServicoUUID) => enderecoTransportador = ObservableFuture(ordemServicoService.enderecoTransportador(ordemServicoUUID));

  @action
  void setStatusAplicaco(int status) => statusAplicado = status;

  @action
  void setProgressoUploadTexto(String texto) {
    progressoUploadTexto = texto;
  }

  @action
  void setWorkingUpload(bool v) {
    progressoUploadIsWorking = v;
  }

  Future avaliarServico(String ordemServicoUUID, {
    int notaEntregador,
    String comentarioEntregador,
    int notaTransportador,
    String comentarioTransportador,
  }) => ordemServicoService.avaliarServico(ordemServicoUUID,
    comentarioEntregador: comentarioEntregador,
    notaEntregador: notaEntregador,
    comentarioTransportador: comentarioTransportador,
    notaTransportador: notaTransportador
  );

  @action
  Future listaOrdensServico({int status}) => ordensServico = ObservableFuture(ordemServicoService.listarOrdensServico(status: status));

  @action
  Future listarTransportadoresDisponiveis(String ordemServicoId) => transportadoresDisponiveis = ObservableFuture(ordemServicoService.listaViagensCompativeis(ordemServicoId));

  @action
  Future listarImagensPedido(String ordemServicoUUID) => imagensPedido = ObservableFuture(ordemServicoService.listarFotos(ordemServicoUUID));

  @action
  Future<void> sendPicture(String ordemServicoUUID, String pathImagem) => ordemServicoService.enviaFoto(ordemServicoUUID, pathImagem);

  @action
  Future<void> obterOrdemPagamento(String ordemServicoUUID) => ordemPagamento = ObservableFuture(ordemServicoService.obterURLPagamento(ordemServicoUUID)); 

  @action
  void addImageContainer() {
    imagensPedido.value.insert(0, ImageUpload());
  }

  @action
  void updateImageContainer(int index, ImageUpload imageUpload) {
    imagensPedido.value[index] = imageUpload;
  }

  Future criarOrdemServico(OrdemServico ordemServico) {
    return ordemServicoService.criarOrdemServico(ordemServico);
  }

  Future selecionarTransportador(String ordemServicoId, String viagemId) {
    return ordemServicoService.adicionarTransportador(ordemServicoId, viagemId);
  }
}