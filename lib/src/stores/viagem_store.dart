import 'package:gooex_mobile/src/models/aeroporto.dart';
import 'package:gooex_mobile/src/models/pedido.dart';
import 'package:gooex_mobile/src/models/viagem.dart';
import 'package:gooex_mobile/src/services/centro_distribuicao_service.dart';
import 'package:gooex_mobile/src/services/viagem_service.dart';
import 'package:mobx/mobx.dart';

part 'viagem_store.g.dart';

class ViagemStore = _ViagemStore with _$ViagemStore;

abstract class _ViagemStore with Store {

  final viagemService = ViagemService();
  final centroDistribuicaoService = CentroDistribuicaoService();
  
  @observable
  bool mostrarTudo = false;

  @observable
  DateTime dataPartida;
  
  @observable
  DateTime dataChegada;
  
  @observable
  String horarioPartida;
  
  @observable
  String horarioChegada;

  @observable
  String aeroporto;

  @observable
  bool verPendentes = true;

  @observable
  ObservableFuture<List<Viagem>> viagens;

  @observable
  ObservableFuture<List<Pedido>> pedidos;

  @observable
  ObservableFuture<List<Aeroporto>> aeroportos;

  @action
  void setHorarioPartida(String horario) {
    horarioPartida = horario;
  }

  @action
  void visualizarPendentes(bool v) => verPendentes = v;

  @action
  void setHorarioChegada(String horario) {
    horarioChegada = horario;
  }

  @action
  void setDataPartida(DateTime data) {
    dataPartida = data;
  }

  @action
  void setDataChegada(DateTime data) {
    dataChegada = data;
  }

  @action
  void setAeroporto(String aeroporto) {
    this.aeroporto = aeroporto;
  }

  @action
  void setMostrarTudo(bool mostrarTudo) => this.mostrarTudo = mostrarTudo;

  @action
  Future<void> aceitarPedido(String viagemUUID, String ordemServicoUUID, bool confirma) => viagemService.aceitarOrdemServico(viagemUUID, ordemServicoUUID, confirma);

  @action
  Future listarViagens() => viagens = ObservableFuture(viagemService.listarViagens());

  @action
  Future listarPedidos(String viagemId) async {
    pedidos = ObservableFuture(viagemService.listarPedidos(viagemId));
  }

  @action
  Future listarAeroportos() async {
    aeroportos = ObservableFuture(centroDistribuicaoService.listarAeroportos());
    print('"listarAeroportos()"');
  }

  Future<void> registrarViagem(Viagem viagem) async {
    await viagemService.criarViagem(viagem);
  }

}