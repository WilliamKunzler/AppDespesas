import 'package:despesas/database/dao/despesasdao.dart';
import 'package:despesas/screens/TelaGrafico.dart';
import 'package:flutter/material.dart';
import 'package:despesas/screens/TelaCalendario.dart';
import 'package:despesas/screens/TelaInserir.dart';

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
            padding: const EdgeInsets.symmetric(vertical: 140, horizontal: 30),
            child: Container(
              child: Row(
                children: [
                  OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TelaGrafico()));
                      },
                      child: const Text('Ver Gráficos')),
                  Spacer(),
                  Icon(
                    Icons.pie_chart,
                    size: 130,
                    color: Colors.deepOrangeAccent,
                  )
                ],
              ),
            ),
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
                            return Column(
                              children: dados.map((item) {
                                String area = item['area'];
                                IconData? icone = icones[area];
                                Color? cores = cor[area];

                                return Dismissible(
                                  key: Key(item['id']
                                      .toString()), // Aqui você deve fornecer uma key única para cada item.
                                  onDismissed: (direction) {
                                    // Aqui você pode manipular o evento de exclusão, como remover o item da lista.
                                    setState(() {
                                      deleteByID(item['id']);
                                    });
                                  },
                                  background: Container(color: Colors.red),
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
                                    trailing: Text("R\$ ${item['valor']}",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 17)),
                                  ),
                                );
                              }).toList(),
                            );
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
