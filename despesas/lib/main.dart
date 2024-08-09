import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:despesas/screens/TelaPrincipal.dart';


void main() {
  initializeDateFormatting().then((_) => runApp(MaterialApp(
        home: TelaPrincipal(),
        debugShowCheckedModeBanner: false,
      )));
}





