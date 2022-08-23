import 'package:gooex_mobile/src/models/pedido.dart';
import 'package:gooex_mobile/src/services/ordem_servico_service.dart';
import 'package:gooex_mobile/src/services/viagem_service.dart';
import 'package:mobx/mobx.dart';

part 'pedido_store.g.dart';

class PedidoStore = _PedidoStore with _$PedidoStore;

abstract class _PedidoStore with Store {

  final viagemService = ViagemService();
  final ordemServicoService = OrdemServicoService();

  @observable
  int statusAplicado;

  @observable
  ObservableFuture<List<Pedido>> pedidosCliente;

  @observable
  ObservableFuture<List<Pedido>> pedidosTransportador;

  @action
  Future listarPedidosTransportador({int status}) => pedidosTransportador = ObservableFuture(viagemService.listarPedidosTransportador(status: status));

  @action
  Future listarPedidosCliente({int status}) => pedidosCliente = ObservableFuture(ordemServicoService.listarPedidosCliente(status: status));

  @action
  void setStatusAplicado(int status) => statusAplicado = status;

  // @action
  // Future listarViagens() => viagens = ObservableFuture(viagemService.listarViagens());

}