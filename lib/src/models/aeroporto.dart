class Aeroporto {
  String uuid;
  int cep;
  String numero;
  String complemento;
  String nome;

  Aeroporto({this.uuid, this.cep, this.numero, this.complemento, this.nome});

  Aeroporto.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    cep = json['cep'];
    numero = json['numero'];
    complemento = json['complemento'];
    nome = json['nome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['cep'] = this.cep;
    data['numero'] = this.numero;
    data['complemento'] = this.complemento;
    data['nome'] = this.nome;
    return data;
  }
}
