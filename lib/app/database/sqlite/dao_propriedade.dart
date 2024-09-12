import 'package:projeto_avirario/app/database/sqlite/conexao.dart';
import 'package:projeto_avirario/app/domain/dto/dto_propriedade.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_propriedade.dart';
import 'package:sqflite/sqflite.dart';

class DAOPropriedade implements IDAOPropriedade {
  late Database _db;

  Future<void> _openDatabase() async {
    _db = await Conexao.open();
  }

  @override
  Future<DTOPropriedade> salvar(DTOPropriedade dto) async {
    await _openDatabase();
    if (dto.id == null) {
      final id = await _db.insert(
        'propriedade',
        {
          'nome': dto.nome,
          'localizacao': dto.localizacao,
          'qtdAviario': dto.qtdAviario,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return DTOPropriedade(
        id: id,
        nome: dto.nome,
        localizacao: dto.localizacao,
        qtdAviario: dto.qtdAviario,
        aviarios: dto.aviarios,
      );
    } else {
      await _db.update(
        'propriedade',
        {
          'nome': dto.nome,
          'localizacao': dto.localizacao,
          'qtdAviario': dto.qtdAviario,
        },
        where: 'id = ?',
        whereArgs: [dto.id],
      );
      return dto;
    }
  }

  @override
  Future<void> deletarPropriedade(dynamic id) async {
    await _openDatabase();
    await _db.delete(
      'propriedade',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<DTOPropriedade?> buscarPorId(dynamic id) async {
    await _openDatabase();
    final List<Map<String, dynamic>> maps = await _db.query(
      'propriedade',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      final map = maps.first;
      return DTOPropriedade(
        id: map['id'],
        nome: map['nome'],
        localizacao: map['localizacao'],
        qtdAviario: map['qtdAviario'],
        aviarios: [],
      );
    }
    return null;
  }

  @override
  Future<List<DTOPropriedade>> buscarPropriedade() async {
    await _openDatabase(); 
    final List<Map<String, dynamic>> maps = await _db.query('propriedade');
    return List.generate(maps.length, (i) {
      final map = maps[i];
      return DTOPropriedade(
        id: map['id'],
        nome: map['nome'],
        localizacao: map['localizacao'],
        qtdAviario: map['qtdAviario'],
        aviarios: [], 
      );
    });
  }
}
