import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:projeto_avirario/app/database/sqlite/conexao.dart'; 

void main() async {
  setUpAll(() {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
  });

  test('teste conexão com o banco de dados', () async {
    var db = await Conexao.open();
    expect(db.isOpen, true);

    var tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    expect(tables.any((table) => table['name'] == 'usuario'), true);

    var list = await db.rawQuery('SELECT * FROM usuario');
    
    expect(list.length, greaterThanOrEqualTo(0)); 
  });
}
