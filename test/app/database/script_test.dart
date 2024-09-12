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
    });

    var list = await db.rawQuery('SELECT * FROM usuario');
    
    expect(list.length, 3);

    expect(list[0]['nome'], 'Admin');
    expect(list[0]['email'], 'admin@example.com');
    expect(list[0]['senha'], 'admin123');
    
    expect(list[1]['nome'], 'User1');
    expect(list[1]['email'], 'user1@example.com');
    expect(list[1]['senha'], 'password1');
    
    expect(list[2]['nome'], 'User2');
    expect(list[2]['email'], 'user2@example.com');
    expect(list[2]['senha'], 'password2');
  });
}
