import 'package:gooex_mobile/src/models/image_upload.dart';
import 'package:gooex_mobile/src/models/ordem_servico_entregador.dart';
import 'package:gooex_mobile/src/services/centro_distribuicao_service.dart';
import 'package:mobx/mobx.dart';

part 'entregas_store.g.dart';

class EntregaStore = _EntregaStore with _$EntregaStore;

abstract class _EntregaStore with Store {
  final CentroDistribuicaoService _centroDistribuicaoService =
      CentroDistribuicaoService();

  @observable
  ObservableFuture<List<OrdemServicoEntregador>> entregasDisponiveis;

  @observable
  ObservableFuture<List<OrdemServicoEntregador>> minhasEntregas;

  @observable
  ObservableFuture<List<ImageUpload>> shippingImages =
      ObservableFuture(Future.value([
    ImageUpload(),
    ImageUpload(),
    ImageUpload(),
  ]));

  @observable
  String progressoUploadTexto = 'Iniciando upload';

  @observable
  bool progressoUploadIsWorking = false;

  @action
  void setProgressoUploadTexto(String texto) {
    progressoUploadTexto = texto;
  }

  @action
  void setWorkingUpload(bool v) {
    progressoUploadIsWorking = v;
  }

  @action
  Future<void> listarEntregasDisponiveis() => entregasDisponiveis =
      ObservableFuture(_centroDistribuicaoService.listarEntregasDisponiveis());

  @action
  Future<void> listarMinhasEntregas() => minhasEntregas =
      ObservableFuture(_centroDistribuicaoService.listarEntregas());

  @action
  Future<void> sendPicture(String entregaUUID, String pathImagem) async {
    print('Sending picture: $entregaUUID / $pathImagem');
    await _centroDistribuicaoService.enviaFoto(entregaUUID, pathImagem);
  }

  Future<OrdemServicoEntregador> aceitarEntrega(String uuidPedido) async {
    return _centroDistribuicaoService.aceitarEntrega(uuidPedido);
  }

  Future<void> cancelarEntrega(String uuidEntrega) async {
    return _centroDistribuicaoService.cancelarEntrega(uuidEntrega);
  }
}
