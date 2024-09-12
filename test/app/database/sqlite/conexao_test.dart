import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_avirario/app/database/script.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:projeto_avirario/app/database/sqlite/conexao.dart';

void main() {
  late Database db;

  setUpAll(() async {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
    db = await Conexao.open();

    // Limpar o banco de dados: remover todas as tabelas existentes
    var tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    for (var table in tables) {
      var tableName = table['name'] as String;
      if (tableName != 'sqlite_sequence') { // 'sqlite_sequence' é usada para manter IDs autoincrementados, não remover
        await db.execute('DROP TABLE IF EXISTS $tableName');
      }
    }

    // Recriar as tabelas após limpar o banco
    for (var script in createTables) {
      await db.execute(script);
    }
  });

  test('Teste conexão com o banco de dados e criação de tabelas', () async {
    expect(db.isOpen, true);

    var tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    expect(tables.any((table) => table['name'] == 'usuario'), true);
    expect(tables.any((table) => table['name'] == 'propriedade'), true);
    expect(tables.any((table) => table['name'] == 'lote'), true);
    expect(tables.any((table) => table['name'] == 'aviario'), true);

    var listUsuarios = await db.rawQuery('SELECT * FROM usuario');
    expect(listUsuarios.length, greaterThanOrEqualTo(0));

    var listPropriedades = await db.rawQuery('SELECT * FROM propriedade');
    expect(listPropriedades.length, greaterThanOrEqualTo(0));

    var listLotes = await db.rawQuery('SELECT * FROM lote');
    expect(listLotes.length, greaterThanOrEqualTo(0));

    var listAviarios = await db.rawQuery('SELECT * FROM aviario');
    expect(listAviarios.length, greaterThanOrEqualTo(0));
  });
}
