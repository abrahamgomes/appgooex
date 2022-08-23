class EnderecoTransportador {
  String cep;
  String municipio;
  String bairro;
  String estado;
  String logradouro;
  String descricao;
  String numero;
  String complemento;

  EnderecoTransportador(
      {this.cep,
      this.municipio,
      this.bairro,
      this.estado,
      this.logradouro,
      this.descricao,
      this.numero,
      this.complemento});

  EnderecoTransportador.fromJson(Map<String, dynamic> json) {
    cep = json['cep'];
    municipio = json['municipio'];
    bairro = json['bairro'];
    estado = json['estado'];
    logradouro = json['logradouro'];
    descricao = json['descricao'];
    numero = json['numero'];
    complemento = json['complemento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cep'] = this.cep;
    data['municipio'] = this.municipio;
    data['bairro'] = this.bairro;
    data['estado'] = this.estado;
    data['logradouro'] = this.logradouro;
    data['descricao'] = this.descricao;
    data['numero'] = this.numero;
    data['complemento'] = this.complemento;
    return data;
  }
}
