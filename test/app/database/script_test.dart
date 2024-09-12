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
    });

    // Verificar a tabela de usuários
    var usuarios = await db.rawQuery('SELECT * FROM usuario');
    
    expect(usuarios.length, 3);

    expect(usuarios[0]['nome'], 'Admin');
    expect(usuarios[0]['email'], 'admin@example.com');
    expect(usuarios[0]['senha'], 'admin123');
    
    expect(usuarios[1]['nome'], 'User1');
    expect(usuarios[1]['email'], 'user1@example.com');
    expect(usuarios[1]['senha'], 'password1');
    
    expect(usuarios[2]['nome'], 'User2');
    expect(usuarios[2]['email'], 'user2@example.com');
    expect(usuarios[2]['senha'], 'password2');

    // Verificar a tabela de propriedades
    var propriedades = await db.rawQuery('SELECT * FROM propriedade');
    
    expect(propriedades.length, 3);

    expect(propriedades[0]['nome'], 'Propriedade A');
    expect(propriedades[0]['localizacao'], 'Localização A');
    expect(propriedades[0]['qtdAviario'], 5);

    expect(propriedades[1]['nome'], 'Propriedade B');
    expect(propriedades[1]['localizacao'], 'Localização B');
    expect(propriedades[1]['qtdAviario'], 10);

    expect(propriedades[2]['nome'], 'Propriedade C');
    expect(propriedades[2]['localizacao'], 'Localização C');
    expect(propriedades[2]['qtdAviario'], 8);
  });
}
