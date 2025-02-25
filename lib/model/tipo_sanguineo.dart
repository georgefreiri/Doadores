class TipoSanguineo {
  String? tipo;
  String? idade;
  String? media;
  String? guid;

  TipoSanguineo({this.tipo, this.idade, this.media, this.guid});

  TipoSanguineo.fromJson(Map json) {
    tipo = json['tipo'];
    idade = json['idade'];
    media = json['media'];
    guid = json['guid'];
  }

  Map toJson() {
    return {
      'tipo': this.tipo,
      'idade': this.idade == null ? '' : this.idade,
      'media': this.media,
      'guid': this.guid
    };
  }
}
