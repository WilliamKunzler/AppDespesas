import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:despesas/screens/TelaPrincipal.dart';
import 'package:despesas/database/dao/despesasdao.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';


void main() {
  if (Platform.isWindows || Platform.isLinux){
    sqfliteFfiInit();
  }

  databaseFactory = databaseFactoryFfi;

  debugPrint(findall().toString());

  initializeDateFormatting().then((_) => runApp(MaterialApp(
        home: TelaPrincipal(),
        debugShowCheckedModeBanner: false,
      )));
}





