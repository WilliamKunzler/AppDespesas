import 'package:flutter/material.dart';
import 'package:despesas/screens/TelaCalendario.dart';
import 'package:despesas/screens/TelaPrincipal.dart';

class TelaGrafico extends StatefulWidget {
  @override
  State<TelaGrafico> createState() => _TelaGraficoState();
}

enum Calendar { diario, semanal, mensal, anual }

class _TelaGraficoState extends State<TelaGrafico> {
  Calendar calendarView = Calendar.diario;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          "images/logo.png",
        ),
      ),
      body: Column(
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
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TelaPrincipal()));
                  },
                  icon: Icon(
                    Icons.chevron_left_rounded,
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
