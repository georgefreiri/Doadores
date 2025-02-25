class DoadorEstado {

  String? estado;
  int? quantidade;
  String? guid;

  DoadorEstado({this.estado, this.quantidade, this.guid});

  DoadorEstado.fromJson(Map json) {
    estado = json['estado'];
    quantidade = json['quantidade'];
    guid = json['guid'];
  }

  Map toJson() {
    return {
      'estado': this.estado,
      'quantidade': this.quantidade,
      'guid': this.guid
    };
  }
}