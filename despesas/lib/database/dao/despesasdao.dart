import 'package:flutter/cupertino.dart';
import 'package:despesas/database/db.dart';
import 'package:sqflite/sqflite.dart';
import '../../model/despesas.dart';

Future<int> insertDespesas(Despesas despesas) async {
  Database db = await getDatabase();
  return db.insert('despesas', despesas.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<List<Map>> findall() async {
  Database db = await getDatabase();
  List<Map<String, dynamic>> dados = await db.query('despesas');
  dados.forEach((despesas) {
    print(despesas);
  });
  return dados;
}

Future<int> deleteByID(int id) async {
  debugPrint("Deletando o ID: $id");
  Database db = await getDatabase();
  return db.delete('despesas', where: "id = ?", whereArgs: [id]);
}

Future<List<Map<String, dynamic>>> selectData(String data) async {
  debugPrint("Procurando: $data");
  Database db = await getDatabase();
  List<Map<String, dynamic>> result = await db.query(
    'despesas', 
    where: "data = ?", 
    whereArgs: [data]
  ); 
  return result;
}