import 'package:flutter/cupertino.dart';
import 'package:despesas/database/db.dart';
import 'package:sqflite/sqflite.dart';
import '../../model/despesas.dart';

Future<int> insertDespesas(Despesas despesas) async{
  Database db = await getDatabase();
  return db.insert('despesas', despesas.toMap(),
   conflictAlgorithm: ConflictAlgorithm.replace);

}
Future<List<Map>> findall() async{
  Database db = await getDatabase();
  List<Map<String, dynamic>> dados = await db.query('despesas');
 dados.forEach((despesas){
  print(despesas);
   
});
return dados;
}

Future<int> deleteByID(int id)async{
  debugPrint("Deletando o ID: $id");
  Database db = await getDatabase();
  return db.delete('dogs', where: "id = ?", whereArgs: [id]);
}