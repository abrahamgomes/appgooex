class Viagem {
  String uuid;
  String dataPartida;
  String dataChegada;
  double bagagemLivre;
  double nota;
  List<String> comentarios;
  String numeroOrigem, complementoOrigem, numeroDestino, complementoDestino;
  String cepOrigem, cepDestino;
  String cepOrigemString, cepDestinoString;
  String municipioOrigem, municipioDestino;
  String aeroporto;

  Viagem(
      {this.uuid,
      this.dataPartida,
      this.dataChegada,
      this.cepOrigemString,
      this.numeroOrigem,
      this.complementoOrigem,
      this.numeroDestino,
      this.complementoDestino,
      this.cepDestinoString,
      this.bagagemLivre,
      this.aeroporto,
      this.nota,
      this.comentarios});

  Viagem.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    dataPartida = json['data_partida'];
    dataChegada = json['data_chegada'];
    bagagemLivre = json['bagagem_livre'];
    nota = (json['nota'].runtimeType == int) ? (json['nota'] as int).toDouble() : json['nota'];
    comentarios = json['comentarios'] != null ? json['comentarios'].cast<String>() : [].cast<String>();
    municipioOrigem = json['municipio_origem'];
    municipioDestino = json['municipio_destino'];
    aeroporto = json['nome_aeroporto'];
  }

  Viagem.fromJsonTransportador(Map<String, dynamic> json) {
    uuid = json['uuid'];
    dataPartida = json['data_partida'];
    dataChegada = json['data_chegada'];
    bagagemLivre = json['bagagem_livre'];
    numeroOrigem = json['numero_origem'];
    complementoOrigem = json['complemento_origem'];
    numeroDestino = json['numero_destino'];
    complementoDestino = json['complemento_destino'];
    cepOrigem = json['cep_origem'];
    cepDestino = json['cep_destino'];
    municipioOrigem = json['municipio_origem'];
    municipioDestino = json['municipio_destino'];
    aeroporto = json['nome_aeroporto'];
  }

  Map<String, dynamic> toJsonTransportador() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data_partida'] = this.dataPartida;
    data['data_chegada'] = this.dataChegada;
    data['numero_origem'] = this.numeroOrigem;
    data['complemento_origem'] = this.complementoOrigem;
    data['numero_destino'] = this.numeroDestino;
    data['complemento_destino'] = this.complementoDestino;
    data['cep_origem'] = this.cepOrigemString;
    data['cep_destino'] = this.cepDestinoString;
    data['nome_aeroporto'] = this.aeroporto;
    
    return data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['data_partida'] = this.dataPartida;
    data['data_chegada'] = this.dataChegada;
    data['bagagem_livre'] = this.bagagemLivre;
    data['nota'] = this.nota;
    data['comentarios'] = this.comentarios;
    data['municipio_origem'] = this.municipioOrigem;
    data['municipio_destino'] = this.municipioDestino;
    data['nome_aeroporto'] = this.aeroporto;
    return data;
  }
}
