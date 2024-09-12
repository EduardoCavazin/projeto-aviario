import 'package:projeto_avirario/app/domain/dto/dto_usuario.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_usuario.dart';
import 'package:projeto_avirario/app/database/sqlite/conexao.dart';
import 'package:sqflite/sqflite.dart';

class DAOUsuario implements IDAOUsuario {
  late Database _db;

  Future<void> _openDatabase() async {
    _db = await Conexao.open();
  }

  @override
  Future<DTOUsuario> salvar(DTOUsuario dto) async {
    await _openDatabase();
    if (dto.id == null) {
      final id = await _db.insert(
        'usuario',
        {
          'nome': dto.nome,
          'email': dto.email,
          'senha': dto.senha,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return DTOUsuario(
        id: id,
        nome: dto.nome,
        email: dto.email,
        senha: dto.senha,
      );
    } else {
      await _db.update(
        'usuario',
        {
          'nome': dto.nome,
          'email': dto.email,
          'senha': dto.senha,
        },
        where: 'id = ?',
        whereArgs: [dto.id],
      );
      return dto;
    }
  }

  @override
  Future<void> deletar(dynamic id) async {
    await _openDatabase();
    await _db.delete(
      'usuario',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<DTOUsuario?> buscarPorId(dynamic id) async {
    await _openDatabase();
    final List<Map<String, dynamic>> maps = await _db.query(
      'usuario',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      final map = maps.first;
      return DTOUsuario(
        id: map['id'],
        nome: map['nome'],
        email: map['email'],
        senha: map['senha'],
      );
    }
    return null;
  }

  @override
  Future<List<DTOUsuario>> buscarUsuarios() async {
    await _openDatabase();
    final List<Map<String, dynamic>> maps = await _db.query('usuario');
    return List.generate(maps.length, (i) {
      final map = maps[i];
      return DTOUsuario(
        id: map['id'],
        nome: map['nome'],
        email: map['email'],
        senha: map['senha'],
      );
    });
  }
}
