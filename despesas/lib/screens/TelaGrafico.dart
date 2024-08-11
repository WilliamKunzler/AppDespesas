import 'package:flutter/material.dart';
import 'package:despesas/screens/TelaCalendario.dart';
import 'package:despesas/screens/TelaPrincipal.dart';
import 'package:despesas/database/dao/despesasdao.dart';
import 'package:fl_chart/fl_chart.dart';

class TelaGrafico extends StatefulWidget {
  @override
  State<TelaGrafico> createState() => _TelaGraficoState();
}

enum Calendar { diario, semanal, mensal, anual }

class _TelaGraficoState extends State<TelaGrafico> {
  double total = 0.0;
  Calendar calendarView = Calendar.diario;

  bool circular = true;
  bool barra = false;

  String graficoLabel = "";
  List areas = [
    "Saúde",
    "Casa",
    "Transporte",
    "Presentes",
    "Outros",
    "Alimentação"
  ];

  Map valores = {
    "Saúde": null,
    "Casa": null,
    "Transporte": null,
    "Presentes": null,
    "Outros": null,
    "Alimentação": null
  };

  Future<void> getArea() async {
    for (String area in areas) {
      double temtotal = 0.0;
      List<Map<String, dynamic>> todasAreas = await selectArea(area);
      if (area == area) {
        for (int i = 0; i < todasAreas.length; i++)
          temtotal += todasAreas[i]['valor'];
        setState(() {
          total += temtotal;
          valores[area] = temtotal;
        });
        print(valores);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getArea();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          "images/logo.png",
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              child: SegmentedButton(
                segments: <ButtonSegment>[
                  ButtonSegment(value: Calendar.diario, label: Text("Diário")),
                  ButtonSegment(
                      value: Calendar.semanal, label: Text("Semanal")),
                  ButtonSegment(value: Calendar.mensal, label: Text("Mensal")),
                  ButtonSegment(value: Calendar.anual, label: Text("Anual")),
                ],
                selected: {calendarView},
                onSelectionChanged: (Set newSelection) {
                  setState(() {
                    calendarView = newSelection.first;
                    String opcao = calendarView.toString().split('.').last;
                    debugPrint("${opcao}");
                  });
                },
              ),
            ),
          ),
          Center(
            child: valores.values.contains(null)
                ? CircularProgressIndicator()
                : Stack(alignment: Alignment.center, children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 90,
                        sections: valores.entries.map((entry) {
                          return PieChartSectionData(
                            titlePositionPercentageOffset: 1.42,
                            value: entry.value,
                            title: '${entry.value} \n R\$',
                            color: _getColorForArea(entry.key),
                            radius: 60,
                            titleStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 0, 0, 0)),
                          );
                        }).toList(),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Valor Total',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'R\$ ${total}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 70, right: 70, top: 600),
            child: Row(
              children: [
                Row(
                  children: [
                    Checkbox(
                        value: circular,
                        onChanged: (bool? value) {
                          setState(() {
                            if (barra == true) {
                              barra = false;
                              circular = value!;
                            } else {
                              barra = true;
                              circular = false;
                            }
                          });
                        }),
                    Text(
                      "Circular",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Checkbox(
                        value: barra,
                        onChanged: (bool? value) {
                          setState(() {
                            if (circular == true) {
                              circular = false;
                              barra = value!;
                            } else {
                              circular = true;
                              barra = false;
                            }
                          });
                        }),
                    Text(
                      "Barras",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 50.0,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => TelaPrincipal()));
                },
                icon: Icon(
                  Icons.chevron_left_rounded,
                  size: 40.0,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TelaCalendario()));
                },
                icon: Icon(
                  Icons.calendar_month_outlined,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _getColorForArea(String area) {
  switch (area) {
    case "Saúde":
      return Colors.blue;
    case "Casa":
      return Colors.red;
    case "Transporte":
      return Colors.green;
    case "Presentes":
      return Colors.orange;
    case "Outros":
      return Colors.purple;
    case "Alimentação":
      return Colors.yellow;
    default:
      return Colors.grey;
  }
}
