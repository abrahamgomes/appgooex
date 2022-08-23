import 'package:gooex_mobile/src/models/ordem_servico.dart';
import 'package:gooex_mobile/src/models/viagem.dart';

class Pedido {
  String uuid;
  OrdemServico ordemServico;
  Viagem viagem;
  int status;
  String valorSedex;
  String valorGooex;
  String valorTransportador;
  String valorEntregador;
  String valorDespesas;
  String valorCliente;
  double valor;

  Pedido(
      {this.uuid,
      this.ordemServico,
      this.viagem,
      this.valor,
      this.status,
      this.valorSedex,
      this.valorGooex,
      this.valorTransportador,
      this.valorEntregador,
      this.valorDespesas,
      this.valorCliente});

  Pedido.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    ordemServico = json['ordem_servico'] != null
        ? new OrdemServico.fromJson(json['ordem_servico'])
        : null;
    viagem =
        json['viagem'] != null ? new Viagem.fromJson(json['viagem']) : null;
    status = json['status'];
    valorSedex = json['valor_sedex'];
    valorGooex = json['valor_gooex'];
    valorTransportador = json['valor_transportador'];
    valorEntregador = json['valor_entregador'];
    valorDespesas = json['valor_despesas'];
    valorCliente = json['valor_cliente'];
    valor = json['valor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    if (this.ordemServico != null) {
      data['ordem_servico'] = this.ordemServico.toJson();
    }
    if (this.viagem != null) {
      data['viagem'] = this.viagem.toJson();
    }
    data['status'] = this.status;
    data['valor_sedex'] = this.valorSedex;
    data['valor_gooex'] = this.valorGooex;
    data['valor_transportador'] = this.valorTransportador;
    data['valor_entregador'] = this.valorEntregador;
    data['valor_despesas'] = this.valorDespesas;
    data['valor_cliente'] = this.valorCliente;
    data['valor'] = this.valor;
    return data;
  }
}