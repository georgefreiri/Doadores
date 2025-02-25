import 'dart:convert';
import 'dart:math';

import 'package:doador/model/doador_estado.dart';
import 'package:doador/model/doador_sanguineo.dart';
import 'package:doador/model/doadores.dart';
import 'package:doador/model/estado_doadores.dart';
import 'package:doador/model/grupo_sanguineo.dart';
import 'package:doador/model/idade.dart';
import 'package:doador/model/imc.dart';
import 'package:doador/model/percentual_obesos.dart';
import 'package:doador/model/receptor_sanguineo.dart';
import 'package:doador/model/relatorio.dart';
import 'package:doador/model/sexo.dart';
import 'package:doador/model/tipo_sanguineo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:doador/model/tab_home.dart';
import 'package:uuid/uuid.dart';

class HomeSanguineo extends StatefulWidget {
  HomeSanguineo({Key? key});

  @override
  State<HomeSanguineo> createState() => _HomeSanguineoState();
}

class _HomeSanguineoState extends State<HomeSanguineo> {
  TabHome? tabhome = TabHome(id: 1, title: 'Estado doadores', color: Colors.blue);

  bool isLoading = true;

  List<Doador> doadores = [];

  List<DoadorEstado> doadoresEstados = [];
  List<IMC> imcs = [];
  List<PercentualObesos> percentualObesos = [];
  List<TipoSanguineo> tiposSanguineos = [];
  List<GrupoSanguineo> gruposSanguineos = [];

  Relatorio relatorio = Relatorio(guid: Uuid().v1().toString(), nome: 'Relatório de Doadores');

  Map<String, dynamic> map = {};

  Future<void> _loadJson() async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/data.json");
    Iterable iterable = jsonDecode(data);
    Iterable<Doador> iterableArray = iterable.map((model) => Doador.fromJson(model));
    doadores = iterableArray.toList();
    _getDataReportEstados();
    _getDataReportIMC();
    _getDataReportObesos();
    _getDataReportTipoSanguineo();
    _getDataReportGrupoSanguineo();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadJson();
  }

  // Aqui podemos criar um Splash ou Manipular os widgets

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Doadores', style: GoogleFonts.inter(fontSize: 24.0, color: Colors.black)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    child: Text('Relatório de Doadores', style: GoogleFonts.inter(fontSize: 18), textAlign: TextAlign.center),
                  ),
                  Container(
                    height: 35,
                    width: MediaQuery.sizeOf(context).width,
                    child: ListView.builder(
                      itemCount: tabHomes.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        TabHome tabhome = tabHomes[index];

                        return InkWell(
                          onTap: () {
                            setState(() {
                              this.tabhome = tabhome;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(2.0),
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: this.tabhome == tabhome ? tabhome.color : tabhome.color.withValues(alpha: 1.2),
                              borderRadius: BorderRadius.all(Radius.circular(24)),
                            ),
                            child: Text(
                              tabhome.title.toString(),
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  widgetTab(),
                ],
              ),
            ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade400,
        tooltip: 'Envia dados',
        onPressed: () {

          Map guid = {'relatorio': 'doadores', 'guid': relatorio.guid.toString(), 'data': map};

          // Envia dados para o servidor
          String bodyJson = json.encode(guid);
          print(bodyJson);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(bodyJson.toString()),
          ));
        },
        child: Icon(Icons.send_to_mobile_outlined, color: Colors.white, size: 28),
      ),
    );
  }

  Widget widgetTab() {
    switch (tabhome!.id) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: ListTile(title: Text('Estado', style: GoogleFonts.inter(fontSize: 16.0, color: Colors.white)), trailing: Text('Quantidade', style: GoogleFonts.inter(fontSize: 16.0, color: Colors.white))),
            ),
            Container(
              height: MediaQuery.sizeOf(context).height,
              alignment: Alignment.topCenter,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: doadoresEstados.length,
                itemBuilder: (context, index) {
                  DoadorEstado doadorEstado = doadoresEstados[index];

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: ListTile(
                      title: Text(doadorEstado.estado.toString(), style: GoogleFonts.inter(fontSize: 16.0, color: Colors.black87)),
                      trailing: Text(doadorEstado.quantidade.toString(), style: GoogleFonts.inter(fontSize: 16.0, color: Colors.black87)),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('IMC médio em cada faixa de idade de dez em dez anos: 0 a 10; 11 a 20; 21 a 30, etc. (IMC = peso / altura^2)', style: TextStyle(fontSize: 12.0)),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.cyan.shade400,
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: ListTile(title: Text('Faixa', style: GoogleFonts.inter(fontSize: 16.0, color: Colors.white)), trailing: Text('IMC', style: GoogleFonts.inter(fontSize: 16.0, color: Colors.white))),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: imcs.length,
                itemBuilder: (context, index) {
                  IMC imc = imcs[index];

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: ListTile(
                      title: Text(imc.faixa.toString(), style: GoogleFonts.inter(fontSize: 16.0, color: Colors.black87)),
                      trailing: Text(imc.imc.toString(), style: GoogleFonts.inter(fontSize: 16.0, color: Colors.black87)),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      case 3:
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Qual o percentual de obesos entre os homens e entre as mulheres? (É obeso quem tem IMC > 30).', style: TextStyle(fontSize: 12.0)),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent.shade400,
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: ListTile(title: Text('Homens', style: GoogleFonts.inter(fontSize: 16.0, color: Colors.white)), trailing: Text('Mulheres', style: GoogleFonts.inter(fontSize: 16.0, color: Colors.white))),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: percentualObesos.length,
                itemBuilder: (context, index) {
                  PercentualObesos percentualObeso = percentualObesos[index];

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: ListTile(
                      title: Text('${percentualObeso.percentualFeminino!.toStringAsFixed(2)}%', style: GoogleFonts.inter(fontSize: 16.0, color: Colors.black87)),
                      trailing: Text('${percentualObeso.percentualMasculino!.toStringAsFixed(2)}%', style: GoogleFonts.inter(fontSize: 16.0, color: Colors.black87)),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      case 4:
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Qual a média de idade para cada tipo sanguíneo?', style: TextStyle(fontSize: 12.0)),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.orange.shade400,
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: ListTile(title: Text('Média idade', style: GoogleFonts.inter(fontSize: 16.0, color: Colors.white)), trailing: Text('Tipo Sanguíneo', style: GoogleFonts.inter(fontSize: 16.0, color: Colors.white))),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: tiposSanguineos.length,
                itemBuilder: (context, index) {
                  TipoSanguineo tipoSanguineo = tiposSanguineos[index];

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: ListTile(
                      title: Text(tipoSanguineo.media.toString(), style: GoogleFonts.inter(fontSize: 16.0, color: Colors.black87)),
                      trailing: Text(tipoSanguineo.tipo.toString(), style: GoogleFonts.inter(fontSize: 16.0, color: Colors.black87)),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      case 5:
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Somente pessoas com idade de 16 a 69 anos e com peso acima de 50 Kg podem doar sangue.', style: TextStyle(fontSize: 12.0)),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.purple.shade400,
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Tipo Sanguíneo', style: GoogleFonts.inter(fontSize: 14.0, color: Colors.white)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Pode Doador para', style: GoogleFonts.inter(fontSize: 14.0, color: Colors.white)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Pode Receptor de', style: GoogleFonts.inter(fontSize: 14.0, color: Colors.white)),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: gruposSanguineos.length,
                itemBuilder: (context, index) {
                  GrupoSanguineo grupoSanguineo = gruposSanguineos[index];

                  return Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          child: Text(grupoSanguineo.tipoSanguineo.toString(), style: GoogleFonts.inter(fontSize: 16.0, color: Colors.black87)),
                        ),
                        Text(grupoSanguineo.doadores.toString(), style: GoogleFonts.inter(fontSize: 16.0, color: Colors.black87)),
                        Text(grupoSanguineo.receptores.toString(), style: GoogleFonts.inter(fontSize: 16.0, color: Colors.black87))
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      default:
        return Container(child: Text(tabhome!.title.toString()));
    }
  }

  double calculoImc({int? peso, double? altura}) {
    return peso! / pow(altura!, 2);
  }

  void _getDataReportEstados() {
    Map<String, List<String>> mapDoadorEstatdo = {};

    doadores.forEach((doador) {
      if (!mapDoadorEstatdo.containsKey(doador.estado)) {
        mapDoadorEstatdo[doador.estado!] = [];
      }
      mapDoadorEstatdo[doador.estado]!.add(doador.nome.toString());
    });

    int quantidade = 0;
    mapDoadorEstatdo.forEach((key, value) {
      print(quantidade += value.length);
      doadoresEstados.add(DoadorEstado(estado: key, quantidade: value.length, guid: relatorio.guid.toString()));
    });

    map.addAll({'estados': doadoresEstados});
  }

  void _getDataReportIMC() {
    List<List<int>> faixasEtarias = [
      [0, 10],
      [11, 20],
      [21, 30],
      [31, 40],
      [41, 50],
      [51, 60],
      [61, 70],
      [71, 80],
      [81, 90],
    ];

    for (var faixa in faixasEtarias) {
      double somaIMC = 0;
      int contador = 0;

      for (var doador in doadores) {
        if (doador.getIdade() >= faixa[0] && doador.getIdade() <= faixa[1]) {
          double imc = doador.peso! / pow(doador.altura!, 2);
          somaIMC += imc;
          contador++;
        }
      }

      if (contador > 0) {
        double imcMedio = somaIMC / contador;
        imcs.add(IMC(faixa: '${faixa[0]}-${faixa[1]}', imc: '${imcMedio.toStringAsFixed(2)}', guid: relatorio.guid.toString()));
      }
    }

    map.addAll({'imc': imcs});
  }

  void _getDataReportObesos() {
    List<Sexo> masculinos = [];
    List<Sexo> femininos = [];

    for (var doador in doadores) {
      if (doador.sexo!.toString() == 'Masculino' && calculoImc(peso: doador.peso, altura: doador.altura!) > 30) {
        masculinos.add(Sexo(masculino: doador.sexo));
      } else if (doador.sexo!.toString() == 'Feminino' && calculoImc(peso: doador.peso, altura: doador.altura!) > 30) {
        femininos.add(Sexo(feminino: doador.sexo));
      }
    }

    double feminino = (masculinos.length / doadores.length) * 100;
    double masculino = (femininos.length / doadores.length) * 100;

    print(feminino);
    print(masculino);

    percentualObesos.add(PercentualObesos(percentualFeminino: feminino.toDouble(), percentualMasculino: masculino.toDouble(), guid: relatorio.guid.toString()));

    map.addAll({'obesos': percentualObesos});
  }

  void _getDataReportTipoSanguineo() {
    Map<String, List<int>> idadesPorTipoSanguineo = {};

    for (var doador in doadores) {
      if (!idadesPorTipoSanguineo.containsKey(doador.tipoSanguineo)) {
        idadesPorTipoSanguineo[doador.tipoSanguineo!] = [];
      }
      idadesPorTipoSanguineo[doador.tipoSanguineo]!.add(doador.getIdade());
    }

    Map<String, double> mediaIdadesPorTipoSanguineo = {};

    idadesPorTipoSanguineo.forEach((tipo, idades) {
      double somaIdades = idades.fold(0, (sum, idade) => sum + idade);
      double media = somaIdades / idades.length;
      mediaIdadesPorTipoSanguineo[tipo] = media;
    });

    mediaIdadesPorTipoSanguineo.forEach((tipo, media) {
      tiposSanguineos.add(TipoSanguineo(tipo: tipo, media: '${media.toStringAsFixed(2)} anos', guid: relatorio.guid.toString()));
    });

    map.addAll({'tipo_sanguineo': tiposSanguineos});
  }

  void _getDataReportGrupoSanguineo() {
    List<Doador> possiveisDoadores = [];

    for (var doador in doadores) {
      if (doador.getIdade() >= 16 || doador.getIdade() <= 69 && doador.peso! >= 50) {
        possiveisDoadores.add(doador);
      }
    }

    List<TipoSanguineo> tiposSanguineos = [];
    tiposSanguineos.add(TipoSanguineo(tipo: 'A+'));
    tiposSanguineos.add(TipoSanguineo(tipo: 'A-'));
    tiposSanguineos.add(TipoSanguineo(tipo: 'B+'));
    tiposSanguineos.add(TipoSanguineo(tipo: 'B-'));
    tiposSanguineos.add(TipoSanguineo(tipo: 'AB+'));
    tiposSanguineos.add(TipoSanguineo(tipo: 'AB-'));
    tiposSanguineos.add(TipoSanguineo(tipo: 'O+'));
    tiposSanguineos.add(TipoSanguineo(tipo: 'O-'));

    Map<String, Map<List<DoadorSanguineo>, List<ReceptorSanguineo>>> doadoresPossiveis = {};

    for (var tipoSanguineo in tiposSanguineos) {
      List<DoadorSanguineo> doadoresSanguineos = [];
      List<ReceptorSanguineo> receptorSanguineos = [];

      for (var doador in possiveisDoadores) {
        if (tipoSanguineo.tipo == 'A+') {
          if (doador.tipoSanguineo == 'AB+' || doador.tipoSanguineo == 'A+') {
            doadoresSanguineos.add(DoadorSanguineo(tipoSanguineo: TipoSanguineo(tipo: tipoSanguineo.tipo)));
          }
          if (doador.tipoSanguineo == 'A+' || doador.tipoSanguineo == 'A-' || doador.tipoSanguineo == 'O+' || doador.tipoSanguineo == 'O-') {
            receptorSanguineos.add(ReceptorSanguineo(tipoSanguineo: TipoSanguineo(tipo: doador.tipoSanguineo)));
          }
        } else if (tipoSanguineo.tipo == 'A-') {
          if (doador.tipoSanguineo == 'A+' || doador.tipoSanguineo == 'A-' || doador.tipoSanguineo == 'AB+' || doador.tipoSanguineo == 'AB-') {
            doadoresSanguineos.add(DoadorSanguineo(tipoSanguineo: TipoSanguineo(tipo: doador.tipoSanguineo)));
          }
          if (doador.tipoSanguineo == 'A-' || doador.tipoSanguineo == 'O-') {
            receptorSanguineos.add(ReceptorSanguineo(tipoSanguineo: TipoSanguineo(tipo: doador.tipoSanguineo)));
          }
        } else if (tipoSanguineo.tipo == 'B+') {
          if (doador.tipoSanguineo == 'B+' || doador.tipoSanguineo == 'AB+') {
            doadoresSanguineos.add(DoadorSanguineo(tipoSanguineo: TipoSanguineo(tipo: doador.tipoSanguineo)));
          }
          if (doador.tipoSanguineo == 'B+' || doador.tipoSanguineo == 'B-' || doador.tipoSanguineo == 'O+' || doador.tipoSanguineo == 'O-') {
            receptorSanguineos.add(ReceptorSanguineo(tipoSanguineo: TipoSanguineo(tipo: doador.tipoSanguineo)));
          }
        } else if (tipoSanguineo.tipo == 'B-') {
          if (doador.tipoSanguineo == 'B+' || doador.tipoSanguineo == 'B-' || doador.tipoSanguineo == 'AB+' || doador.tipoSanguineo == 'AB-') {
            doadoresSanguineos.add(DoadorSanguineo(tipoSanguineo: TipoSanguineo(tipo: doador.tipoSanguineo)));
          }
          if (doador.tipoSanguineo == 'B-' || doador.tipoSanguineo == 'O-') {
            receptorSanguineos.add(ReceptorSanguineo(tipoSanguineo: TipoSanguineo(tipo: doador.tipoSanguineo)));
          }
        } else if (tipoSanguineo.tipo == 'AB+') {
          if (doador.tipoSanguineo == 'AB+') {
            doadoresSanguineos.add(DoadorSanguineo(tipoSanguineo: TipoSanguineo(tipo: doador.tipoSanguineo)));
          }
          if (doador.tipoSanguineo == 'A+' || doador.tipoSanguineo == 'B+' || doador.tipoSanguineo == 'O+' || doador.tipoSanguineo == 'AB+' || doador.tipoSanguineo == 'A-' || doador.tipoSanguineo == 'B-' || doador.tipoSanguineo == 'O-' || doador.tipoSanguineo == 'AB-') {
            receptorSanguineos.add(ReceptorSanguineo(tipoSanguineo: TipoSanguineo(tipo: doador.tipoSanguineo)));
          }
        } else if (tipoSanguineo.tipo == 'AB-') {
          if (doador.tipoSanguineo == 'AB+' || doador.tipoSanguineo == 'AB-') {
            doadoresSanguineos.add(DoadorSanguineo(tipoSanguineo: TipoSanguineo(tipo: doador.tipoSanguineo)));
          }
          if (doador.tipoSanguineo == 'A-' || doador.tipoSanguineo == 'B-' || doador.tipoSanguineo == 'O-' || doador.tipoSanguineo == 'AB-') {
            receptorSanguineos.add(ReceptorSanguineo(tipoSanguineo: TipoSanguineo(tipo: doador.tipoSanguineo)));
          }
        } else if (tipoSanguineo.tipo == 'O+') {
          if (doador.tipoSanguineo == 'A+' || doador.tipoSanguineo == 'B+' || doador.tipoSanguineo == 'O+' || doador.tipoSanguineo == 'AB+') {
            doadoresSanguineos.add(DoadorSanguineo(tipoSanguineo: TipoSanguineo(tipo: doador.tipoSanguineo)));
          }
          if (doador.tipoSanguineo == 'O+' || doador.tipoSanguineo == 'O-') {
            receptorSanguineos.add(ReceptorSanguineo(tipoSanguineo: TipoSanguineo(tipo: doador.tipoSanguineo)));
          }
        } else if (tipoSanguineo.tipo == 'O-') {
          if (doador.tipoSanguineo == 'A+' || doador.tipoSanguineo == 'B+' || doador.tipoSanguineo == 'O+' || doador.tipoSanguineo == 'AB+' || doador.tipoSanguineo == 'A-' || doador.tipoSanguineo == 'B-' || doador.tipoSanguineo == 'O-' || doador.tipoSanguineo == 'AB-') {
            doadoresSanguineos.add(DoadorSanguineo(tipoSanguineo: TipoSanguineo(tipo: doador.tipoSanguineo)));
          }
          if (doador.tipoSanguineo == 'O-') {
            print('${doador.nome}' + 'Tipo: ' + '${doador.tipoSanguineo}');
            receptorSanguineos.add(ReceptorSanguineo(tipoSanguineo: TipoSanguineo(tipo: doador.tipoSanguineo)));
          }
        }
      }

      doadoresPossiveis.addAll({
        tipoSanguineo.tipo.toString(): {doadoresSanguineos: receptorSanguineos}
      });
    }

    doadoresPossiveis.forEach((receptor, doadores) {
      int doadoresSanguineos = 0;
      int receptorSanguineos = 0;
      doadores.forEach(
        (key, value) {
          doadoresSanguineos = key.length;
          receptorSanguineos = value.length;
        },
      );
      gruposSanguineos.add(GrupoSanguineo(tipoSanguineo: '$receptor', doadores: doadoresSanguineos.toString(), receptores: receptorSanguineos.toString(), guid: relatorio.guid.toString()));
    });

    map.addAll({'grupo_sanguineo': gruposSanguineos});

    this.isLoading = false;
  }
}
