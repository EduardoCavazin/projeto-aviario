import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:projeto_avirario/app/database/script.dart';

class Conexao {
  static late Database _db;
  static bool isInitialized = false;

  static Future<Database> open() async {
    if (isInitialized) {
      return _db;
    } else {
      var path = join(await getDatabasesPath(), 'banco.db');
      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          for (var tableScript in createTables) {
            await db.execute(tableScript);
          }
          for (var insertScript in insertUsuarios) {
            await db.execute(insertScript);
          }
        },
      );
      isInitialized = true;
      return _db;
    }
  }
}