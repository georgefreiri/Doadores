import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Doador {
  String? nome;
  String? cpf;
  String? rg;
  String? dataNasc;
  String? sexo;
  String? mae;
  String? pai;
  String? email;
  String? cep;
  String? endereco;
  int? numero;
  String? bairro;
  String? cidade;
  String? estado;
  String? telefoneFixo;
  String? celular;
  double? altura;
  int? peso;
  String? tipoSanguineo;

  Doador({this.nome,
    this.cpf,
    this.rg,
    this.dataNasc,
    this.sexo,
    this.mae,
    this.pai,
    this.email,
    this.cep,
    this.endereco,
    this.numero,
    this.bairro,
    this.cidade,
    this.estado,
    this.telefoneFixo,
    this.celular,
    this.altura,
    this.peso,
    this.tipoSanguineo});

  Doador.fromJson(Map json) {
    nome = json['nome'];
    cpf = json['cpf'];
    rg = json['rg'];
    dataNasc = json['data_nasc'];
    sexo = json['sexo'];
    mae = json['mae'];
    pai = json['pai'];
    email = json['email'];
    cep = json['cep'];
    endereco = json['endereco'];
    numero = json['numero'];
    bairro = json['bairro'];
    cidade = json['cidade'];
    estado = json['estado'];
    telefoneFixo = json['telefone_fixo'];
    celular = json['celular'];
    altura = json['altura'];
    peso = json['peso'];
    tipoSanguineo = json['tipo_sanguineo'];
  }

  Map toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['cpf'] = this.cpf;
    data['rg'] = this.rg;
    data['data_nasc'] = this.dataNasc;
    data['sexo'] = this.sexo;
    data['mae'] = this.mae;
    data['pai'] = this.pai;
    data['email'] = this.email;
    data['cep'] = this.cep;
    data['endereco'] = this.endereco;
    data['numero'] = this.numero;
    data['bairro'] = this.bairro;
    data['cidade'] = this.cidade;
    data['estado'] = this.estado;
    data['telefone_fixo'] = this.telefoneFixo;
    data['celular'] = this.celular;
    data['altura'] = this.altura;
    data['peso'] = this.peso;
    data['tipo_sanguineo'] = this.tipoSanguineo;
    return data;
  }

  int getIdade() {

    DateTime dataAtual = DateTime.now();
    DateTime dataNascimento = DateFormat('dd/mm/yyyy').parse(this.dataNasc!, false);

    return (dataAtual.year - dataNascimento.year).toInt();
  }
}