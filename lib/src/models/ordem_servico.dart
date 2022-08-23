class OrdemServico {
  String uuid;
  dynamic cliente;
  dynamic cep;
  String numero;
  String complemento;
  int comprimento;
  int altura;
  int largura;
  double peso;
  int status;
  String data_hora_criacao; 

  OrdemServico(
      {this.uuid,
      this.cliente,
      this.cep,
      this.numero,
      this.complemento,
      this.comprimento,
      this.altura,
      this.largura,
      this.peso,
      this.status,
      this.data_hora_criacao });

  OrdemServico.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    cliente = json['cliente'];
    cep = json['cep'];
    numero = json['numero'];
    complemento = json['complemento'];
    comprimento = json['comprimento'];
    altura = json['altura'];
    largura = json['largura'];
    peso = json['peso'];
    data_hora_criacao = json['data_hora_criacao']; 
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['cliente'] = this.cliente;
    data['cep'] = this.cep;
    data['numero'] = this.numero;
    data['complemento'] = this.complemento;
    data['comprimento'] = this.comprimento;
    data['altura'] = this.altura;
    data['largura'] = this.largura;
    data['peso'] = this.peso;
    data['status'] = this.status;
    data['data_hora_criacao'] = this.data_hora_criacao; 
    return data;
  }
}
