import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  String caminhoBanco = join(await getDatabasesPath(), 'despesas.db');

  return openDatabase(
    caminhoBanco,
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE despesas('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'descricao TEXT, '
        'valor DOUBLE, '
        'area TEXT, '
        'data DATETIME)'
      );
    },
  );
}
