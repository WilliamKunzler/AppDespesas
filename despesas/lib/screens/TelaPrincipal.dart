import 'package:despesas/database/dao/despesasdao.dart';
import 'package:flutter/material.dart';
import 'package:despesas/screens/TelaCalendario.dart';
import 'package:despesas/screens/Telagrafico.dart';
import 'package:despesas/screens/TelaInserir.dart';

class TelaPrincipal extends StatefulWidget {
  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

enum Calendar { diario, semanal, mensal, anual }

class _TelaPrincipalState extends State<TelaPrincipal> {
  Calendar calendarView = Calendar.diario;

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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 160, horizontal: 8),
            child: OutlinedButton(
                onPressed: () {}, child: const Text('Ver Gráficos')),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 1,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 240, 241, 240),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FutureBuilder(
                      initialData: [],
                      future: findall(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.active:
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Text("ESPERANDO");

                          case ConnectionState.done:
                            List<Map> dados = snapshot.data as List<Map>;
                          // return Column(
                          //   children: dados.map((item) {
                          //     return Dismissible(
                          //       child: ListTile(
                          //         title: Text(" ${item['descricao']}",
                          //             style: TextStyle(
                          //                 fontWeight: FontWeight.bold,
                          //                 fontSize: 19)),
                          //         subtitle: Text("${item['data']}",
                          //             style: TextStyle(fontSize: 15)),
                          //         leading: const Icon(Icons.access_alarm),
                          //         trailing: Text("R\$ ${item['valor']}",
                          //             style: TextStyle(
                          //                 color: Colors.red, fontSize: 17)),
                          //       ),
                          //     );
                          //   }).toList(),
                          // );
                          default:
                            return Text("ERRO");
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
      floatingActionButton: SizedBox(
          height: 80.0,
          width: 80.0,
          child: FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 71, 77, 236),
            child: Icon(
              Icons.add,
              size: 40.0,
              color: Colors.white,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0)),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TelaInserir()));
            },
          )),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 50.0,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TelaGrafico()));
                  },
                  icon: Icon(
                    Icons.bar_chart,
                    size: 40.0,
                  )),
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
                  )),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
