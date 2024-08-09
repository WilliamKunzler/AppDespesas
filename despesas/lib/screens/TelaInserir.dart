import 'package:despesas/database/dao/despesasdao.dart';
import 'package:despesas/screens/TelaGrafico.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:despesas/screens/TelaCalendario.dart';
import 'package:despesas/screens/TelaPrincipal.dart';
import 'package:despesas/model/despesas.dart';

class TelaInserir extends StatefulWidget {
  @override
  State<TelaInserir> createState() => _TelaInserirState();
}

class _TelaInserirState extends State<TelaInserir> {
  List area = [
    "Casa",
    "Alimentação",
    "Saúde",
    "Transporte",
    "Presentes",
    "Outros"
  ];

  List cor = [
    Color.fromARGB(206, 86, 231, 91),
    Color.fromARGB(255, 230, 146, 227),
    Color.fromARGB(255, 91, 155, 207),
    Color.fromARGB(214, 230, 97, 87),
    Color.fromARGB(172, 32, 216, 240),
    Color.fromARGB(207, 247, 169, 53),
  ];

  List icones = [
    Icons.home,
    Icons.local_pizza,
    Icons.health_and_safety,
    Icons.emoji_transportation,
    Icons.card_giftcard_sharp,
    Icons.add,
  ];

  int? selected;

  TextEditingController descpt = TextEditingController();
  TextEditingController valor = TextEditingController();
  TextEditingController pressed = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("images/logo.png"),
      ),
      body: ListView(
        children: [
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: const Text(
                  'Adicionar Despesas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 50, bottom: 20),
              child: TextField(
                controller: descpt,
                decoration: InputDecoration(
                    hintText: "Descrição da despesa",
                    border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 60),
              child: TextField(
                controller: valor,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Valor da despesa", border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                width: double.infinity,
                height: 300,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: area.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(100, 100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          backgroundColor:
                              selected == index ? Colors.black : cor[index],
                          foregroundColor: Colors.white),
                      onPressed: () {
                        String pressed = area[index];
                        setState(() {
                          selected = selected == index ? null : index;
                        });
                      },
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              icones[index],
                              size: 40,
                            ),
                            Text(
                              "${area[index]}",
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            OutlinedButton(
                onPressed: () {
                  DateTime dataAtual = DateTime.now();
                  print(pressed);
                  if (valor.text == "" || descpt.text == "") {
                    final snackBar = SnackBar(
                      content: const Text('Campos não preenchidos!!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  else{
                    setState(() {
                      String descpts = descpt.text;
                      double valores = double.tryParse(valor.text) ?? 0;
                      insertDespesas(Despesas(descricao: descpts, valor: valores, area: area, data: dataAtual));
                    });
                  }
                },
                child: const Text(
                  'Salvar',
                  style: TextStyle(color: Colors.black),
                )),
          ]),
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
                            builder: (context) => TelaPrincipal()));
                  },
                  icon: Icon(
                    Icons.home,
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
    );
  }
}
