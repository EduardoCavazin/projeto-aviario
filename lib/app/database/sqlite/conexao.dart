/* import 'package:path/path.dart';
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
          createTables.forEach(db.execute);
          insertUsuarios.forEach(db.execute);
          insertPropriedades.forEach(db.execute);
          insertLotes.forEach(db.execute);
          insertAviarios.forEach(db.execute);
        },
      );
      isInitialized = true;
      return _db;
    }
  }
}
 */ 
//Estarei utilizando FireBase, então não se faz necessário essa classe.