class IMC {
  String? faixa;
  String? imc;
  String? guid;

  IMC({this.faixa, this.imc, this.guid});

  IMC.fromJson(Map json) {
    faixa = json['faixa'];
    imc = json['imc'];
    guid = json['guid'];
  }

  Map toJson() {
    return {
      'faixa': this.faixa,
      'imc': this.imc,
      'guid': this.guid
    };
  }
}
