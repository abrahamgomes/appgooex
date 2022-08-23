class ImageUpload {
  String uuid;
  String ordemServico;
  String foto;
  String user;
  String path;
  bool canEdit;
  bool fromNetwork;

  ImageUpload({this.uuid, this.ordemServico, this.foto, this.user, this.path, this.canEdit = true, this.fromNetwork = false});

  ImageUpload.fromJson(Map<String, dynamic> json, {bool network}) {
    uuid = json['uuid'];
    ordemServico = json['ordem_servico'];
    foto = json['foto'];
    user = json['user'];
    fromNetwork = network;
    canEdit = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['ordem_servico'] = this.ordemServico;
    data['foto'] = this.foto;
    data['user'] = this.user;
    return data;
  }
}
