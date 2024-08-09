
import 'package:flutter/material.dart';
import 'package:despesas/screens/TelaCalendario.dart';
import 'package:despesas/screens/TelaPrincipal.dart';



class TelaGrafico extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: null,
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
