import 'package:projeto_avirario/app/domain/dto/dto_aviario.dart';
import 'package:projeto_avirario/app/database/sqlite/conexao.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_aviario.dart';

class DAOAviario implements IDAOAviario {
  @override
  Future<DTOAviario> salvar(DTOAviario dto) async {
    final db = await Conexao.open();
    if (dto.id == null) {
      dto.id = await db.insert('aviario', {
        'nome': dto.nome,
        'capacidade': dto.capacidade,
      });
    } else {
      await db.update('aviario', {
        'nome': dto.nome,
        'capacidade': dto.capacidade,
      }, where: 'id = ?', whereArgs: [dto.id]);
    }
    return dto;
  }

  @override
  Future<void> deletar(dynamic id) async {
    final db = await Conexao.open();
    await db.delete('aviario', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<DTOAviario?> buscarPorId(dynamic id) async {
    final db = await Conexao.open();
    final result = await db.query('aviario', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      final aviario = result.first;
      return DTOAviario(
        id: aviario['id'] as int,
        nome: aviario['nome'] as String,
        capacidade: aviario['capacidade'] as int,
      );
    }
    return null;
  }

  @override
  Future<List<DTOAviario>> buscarTodos() async {
    final db = await Conexao.open();
    final result = await db.query('aviario');
    return result.map((aviario) {
      return DTOAviario(
        id: aviario['id'] as int,
        nome: aviario['nome'] as String,
        capacidade: aviario['capacidade'] as int,
      );
    }).toList();
  }
}
