import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:projeto_avirario/app/database/script.dart';

void main() async {
  setUpAll(() {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
  });

  test('teste script create table e insert', () async {
    var db = await openDatabase(inMemoryDatabasePath, version: 1,
        onCreate: (db, version) async {

          for (var script in createTables) {
            await db.execute(script);
          }
          for (var script in insertUsuarios) {
            await db.execute(script);
          }
          for (var script in insertPropriedades) {
            await db.execute(script);
          }
          for (var script in insertLotes) {
            await db.execute(script);
          }
          for (var script in insertAviarios) {
            await db.execute(script);
          }
    });

    // Verificar a tabela de usuários
    var usuarios = await db.rawQuery('SELECT * FROM usuario');
    expect(usuarios.length, 3);

    // Verificar a tabela de propriedades
    var propriedades = await db.rawQuery('SELECT * FROM propriedade');
    expect(propriedades.length, 3);

    // Verificar a tabela de lotes
    var lotes = await db.rawQuery('SELECT * FROM lote');
    expect(lotes.length, 3);

    // Verificar a tabela de aviários
    var aviarios = await db.rawQuery('SELECT * FROM aviario');
    expect(aviarios.length, 3);
  });
}
