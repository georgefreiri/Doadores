class Relatorio {
  String? guid;
  String? nome;

  Relatorio({this.guid, this.nome});

  Map toJson() {
    return {
      'guid': this.guid,
      'nome': this.nome,
    };
  }
}
