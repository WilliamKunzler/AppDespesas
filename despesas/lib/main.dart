import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MaterialApp(
    home: TelaPrincipal(),
  ));
}

class TelaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Image.asset("images/logo.png"),
          backgroundColor: Color.fromARGB(91, 192, 199, 199)),
      backgroundColor: Color.fromARGB(255, 192, 199, 199),
      body: null,
    );
  }
}
