import 'package:despesas/screens/TelaGrafico.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:despesas/screens/TelaCalendario.dart';
import 'package:despesas/screens/TelaPrincipal.dart';
import 'package:despesas/screens/Grid.dart';

class TelaInserir extends StatefulWidget {
  @override
  State<TelaInserir> createState() => _TelaInserirState();
}

class _TelaInserirState extends State<TelaInserir> {
  TextEditingController descpt = TextEditingController();
  TextEditingController valor = TextEditingController();

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
            Grid(),
            OutlinedButton(
                onPressed: () {
                  print(
                    valor.text,
                  );
                  print(
                    descpt.text,
                  );

                  if (valor.text == "" || descpt.text == "") {
                    final snackBar = SnackBar(
                      content: const Text('Campos não preenchidos!!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
