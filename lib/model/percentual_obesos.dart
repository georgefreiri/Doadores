class PercentualObesos {
  String? masculino;
  String? feminino;
  double? percentualMasculino;
  double? percentualFeminino;
  String? guid;

  PercentualObesos({this.masculino, this.feminino, this.percentualMasculino, this.percentualFeminino, this.guid});

  PercentualObesos.fromJson(Map json) {
    masculino = json['masculino'];
    feminino = json['feminino'];
    percentualMasculino = json['percentualMasculino'];
    percentualFeminino = json['percentualFeminino'];
    guid = json['guid'];
  }

  Map toJson() {
    return {
      'masculino': this.masculino == null ? '' : this.masculino,
      'feminino': this.feminino == null ? '' : this.feminino,
      'percentualMasculino': this.percentualMasculino == null ? 0.0 : this.percentualMasculino,
      'percentualFeminino': this.percentualFeminino == null ? 0.0 : this.percentualFeminino,
      'guid': this.guid
    };
  }
}
