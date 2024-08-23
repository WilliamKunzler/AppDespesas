import 'package:flutter/material.dart';
import 'package:despesas/screens/TelaCalendario.dart';
import 'package:despesas/screens/TelaPrincipal.dart';
import 'package:despesas/database/dao/despesasdao.dart';
import 'package:fl_chart/fl_chart.dart';
//https://pub.dev/documentation/fl_chart/latest/fl_chart/AxisTitles-class.html

Color _getColorForArea(String area) {
  switch (area) {
    case "Saúde":
      return Color.fromARGB(255, 91, 155, 207);
    case "Casa":
      return Color.fromARGB(206, 86, 231, 91);
    case "Transporte":
      return Color.fromARGB(214, 230, 97, 87);
    case "Presentes":
      return Color.fromARGB(172, 32, 216, 240);
    case "Outros":
      return Color.fromARGB(207, 247, 169, 53);
    case "Alimentação":
      return Color.fromARGB(255, 230, 146, 227);
    default:
      return Colors.grey;
  }
}

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

DateTime dataAtual = DateTime.now();
String dataSomente =
    "${dataAtual.day.toString().padLeft(2, '0')}-${dataAtual.month.toString().padLeft(2, '0')}-${dataAtual.year}";

class TelaGrafico extends StatefulWidget {
  @override
  State<TelaGrafico> createState() => _TelaGraficoState();
}

String opcao = "";

// enum Calendar { diario, semanal, mensal, anual }

class _TelaGraficoState extends State<TelaGrafico> {
  // Calendar calendarView = Calendar.diario;
  bool circular = true;
  bool barra = false;

  graficos() {
    if (circular == true) {
      return Circular();
    } else {
      return Barras();
    }
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
          Container(
            padding: EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: areas.map((area) {
                return Row(
                  children: [
                    Column(children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: _getColorForArea(area),
                      ),
                      SizedBox(width: 8),
                      Text(area),
                    ])
                  ],
                );
              }).toList(),
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     width: double.infinity,
          //     child: SegmentedButton(
          //       segments: <ButtonSegment>[
          //         ButtonSegment(value: Calendar.diario, label: Text("Diário")),
          //         ButtonSegment(
          //             value: Calendar.semanal, label: Text("Semanal")),
          //         ButtonSegment(value: Calendar.mensal, label: Text("Mensal")),
          //         ButtonSegment(value: Calendar.anual, label: Text("Anual")),
          //       ],
          //       selected: {calendarView},
          //       onSelectionChanged: (Set newSelection) {
          //         setState(() {
          //           calendarView = newSelection.first;
          //           opcao = calendarView.toString().split('.').last;
          //         });
          //       },
          //     ),
          //   ),
          // ),
          graficos(),
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

class Circular extends StatefulWidget {
  @override
  State<Circular> createState() => _CircularState();
}

class _CircularState extends State<Circular> {
  double total = 0.0;

  Future<void> getArea() async {
    for (String area in areas) {
      double temtotal = 0.0;

      List<Map<String, dynamic>> todasAreas = await selectArea(area);
      if (area == area) {
        for (int i = 0; i < todasAreas.length; i++) {
          temtotal += todasAreas[i]['valor'];
        }

        setState(() {
          total += temtotal;
          valores[area] = temtotal;
        });
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
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: valores.values.contains(null)
            ? CircularProgressIndicator()
            : Stack(alignment: Alignment.center, children: [
                PieChart(
                  PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 90,
                      sections: valores.entries.map((entry) {
                        return PieChartSectionData(
                          titlePositionPercentageOffset: 1.47,
                          value: entry.value,
                          title: 'R\$ ${entry.value} ',
                          color: _getColorForArea(entry.key),
                          radius: 60,
                          titleStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 0, 0, 0)),
                        );
                      }).toList(),
                      pieTouchData: PieTouchData(
                        enabled: true,
                      )),
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
    );
  }
}

class Barras extends StatefulWidget {
  @override
  State<Barras> createState() => _BarrasState();
}

class _BarrasState extends State<Barras> {
  double total = 0.0;

  List<BarChartGroupData> bars = [];
  groups() {
    for (String a in areas) {
      if (a == a) {
        BarChartGroupData todos = BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
                y: valores[a],
                width: 12,
                colors: [_getColorForArea(a)],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)))
          ],
        );
        bars.add(todos);
      }
    }
  }

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
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getArea();
    groups();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 130),
          child: Center(
            child: Column(
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
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: AspectRatio(
              aspectRatio: 1.3,
              child: BarChart(BarChartData(
                alignment: BarChartAlignment.spaceAround,
                titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                      showTitles: false,
                    ),
                    leftTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 25,
                        interval: ((valores.values.reduce((curr, next) =>
                                    curr > next ? curr : next)) /
                                10)
                            .ceilToDouble())),
                borderData: FlBorderData(
                  border: Border(
                      top: BorderSide.none,
                      right: BorderSide.none,
                      left: BorderSide(width: 1),
                      bottom: BorderSide(width: 1)),
                ),
                groupsSpace: 10,
                maxY: valores.values
                        .reduce((curr, next) => curr > next ? curr : next) +
                    50,
                barGroups: bars,
              )),
            ),
          ),
        ),
      ],
    );
  }
}
