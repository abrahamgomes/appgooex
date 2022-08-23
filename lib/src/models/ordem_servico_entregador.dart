class OrdemServicoEntregador {
  String uuid;
  String ordemServico;
  String viagem;
  int status;
  String nomeAeroporto;
  String horaDesembarque;
  String destino;
  String municipio;
  String cep;
  double peso;
  int altura;
  int largura;
  int comprimento;
  String telefoneTransportador;
  String telefoneEntregador;
  String nomeTransportador;
  String nomeEntregador;

  OrdemServicoEntregador(
      {this.uuid,
      this.ordemServico,
      this.viagem,
      this.status,
      this.nomeAeroporto,
      this.horaDesembarque,
      this.destino,
      this.municipio,
      this.cep,
      this.peso,
      this.altura,
      this.largura,
      this.comprimento,
      this.telefoneTransportador,
      this.telefoneEntregador,
      this.nomeTransportador,
      this.nomeEntregador
      });

  OrdemServicoEntregador.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    ordemServico = json['ordem_servico'];
    viagem = json['viagem'];
    status = json['status'];
    nomeAeroporto = json['nome_aeroporto'];
    horaDesembarque = json['hora_desembarque'];
    destino = json['destino'];
    municipio = json['municipio'];
    cep = json['cep'];
    peso = json['peso'];
    altura = json['altura'];
    largura = json['largura'];
    comprimento = json['comprimento'];
    telefoneEntregador = json['telefone_entregador'];
    telefoneTransportador = json['telefone_transportador'];
    nomeEntregador = json['nome_entregador'];
    nomeTransportador = json['nome_transportador'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['ordem_servico'] = this.ordemServico;
    data['viagem'] = this.viagem;
    data['status'] = this.status;
    data['nome_aeroporto'] = this.nomeAeroporto;
    data['hora_desembarque'] = this.horaDesembarque;
    data['destino'] = this.destino;
    data['municipio'] = this.municipio;
    data['cep'] = this.cep;
    data['peso'] = this.peso;
    data['altura'] = this.altura;
    data['largura'] = this.largura;
    data['comprimento'] = this.comprimento;
    data['telefone_entregador'] = this.telefoneEntregador;
    data['telefone_transportador'] = this.telefoneTransportador;
    data['nome_entregador'] = this.nomeEntregador;
    data['nome_transportador'] = this.nomeTransportador;
    return data;
  }
}
