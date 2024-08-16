import 'package:despesas/database/dao/despesasdao.dart';
import 'package:despesas/screens/TelaGrafico.dart';
import 'package:flutter/material.dart';
import 'package:despesas/screens/TelaCalendario.dart';
import 'package:despesas/screens/TelaInserir.dart';

DateTime dataAtual = DateTime.now();
String dataSomente =
    "${dataAtual.day.toString().padLeft(2, '0')}-${dataAtual.month.toString().padLeft(2, '0')}-${dataAtual.year}";

class TelaPrincipal extends StatefulWidget {
  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

enum Calendar { diario, semanal, mensal, anual }

class _TelaPrincipalState extends State<TelaPrincipal> {
  Calendar calendarView = Calendar.diario;
  Map icones = {
    "Casa": Icons.home,
    "Alimentação": Icons.local_pizza,
    "Saúde": Icons.health_and_safety,
    "Transporte": Icons.emoji_transportation,
    "Presentes": Icons.card_giftcard_sharp,
    "Outros": Icons.add,
  };

  Map cor = {
    "Casa": Color.fromARGB(206, 86, 231, 91),
    "Alimentação": Color.fromARGB(255, 230, 146, 227),
    "Saúde": Color.fromARGB(255, 91, 155, 207),
    "Transporte": Color.fromARGB(214, 230, 97, 87),
    "Presentes": Color.fromARGB(172, 32, 216, 240),
    "Outros": Color.fromARGB(207, 247, 169, 53),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 130, left: 30, right: 30),
            child: Container(
              child: SizedBox(
                height: 100,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bem-Vindo",
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Ao seu aplicativo pessoal \nde organização financeira!",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.money_off,
                      size: 110,
                      color: Color.fromRGBO(217, 195, 1, 1),
                    )
                  ],
                ),
              ),
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

          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.6,
            maxChildSize: 1,
            builder: (context, scrollController) {
              return Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(245, 246, 246, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 20),
                              child: Text(
                                "Despesas anteriores", // Substitua pelo seu título
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                            ),
                            SizedBox(height: 40),
                            FutureBuilder(
                              initialData: [],
                              future: findall(),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return const Center(
                                      child: Text(
                                          "Houve um erro de conexão com o Banco de Dados"),
                                    );
                                  case ConnectionState.active:
                                  case ConnectionState.waiting:
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );

                                  case ConnectionState.done:
                                    List<Map> dados =
                                        snapshot.data as List<Map>;

                                    return Column(
                                      children: dados.map((item) {
                                        String area = item['area'];
                                        IconData? icone = icones[area];
                                        Color? cores = cor[area];

                                        return Dismissible(
                                          key: Key(item['id'].toString()),
                                          onDismissed: (direction) {
                                            setState(() {
                                              deleteByID(item['id']);
                                            });
                                          },
                                          background:
                                              Container(color: Colors.red),
                                          child: ListTile(
                                            title: Text(" ${item['descricao']}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 19)),
                                            subtitle: Text("${item['data']}",
                                                style: TextStyle(fontSize: 15)),
                                            leading: Icon(
                                              icone,
                                              color: cores,
                                            ),
                                            trailing: Text(
                                                "R\$ ${item['valor']}",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 17)),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  default:
                                    return Text("ERRO");
                                }
                              },
                            ),
                          ]),
                    ),
                  ));
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
                      MaterialPageRoute(builder: (context) => TelaInserir()))
                  .then((value) {
                setState(() {});
              });
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
