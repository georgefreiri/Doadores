class GrupoSanguineo {
  String? tipoSanguineo;
  String? doadores;
  String? receptores;
  String? guid;

  GrupoSanguineo({this.tipoSanguineo, this.doadores, this.receptores, this.guid});

  GrupoSanguineo.fromJson(Map json) {
    tipoSanguineo = json['tipoSanguineo'];
    doadores = json['doadores'];
    receptores = json['receptores'];
    guid = json['guid'];
  }

  Map toJson() {
    return {
      'tipoSanguineo': this.tipoSanguineo,
      'doadores': this.doadores,
      'receptores': this.receptores,
      'guid': this.guid
    };
  }
}