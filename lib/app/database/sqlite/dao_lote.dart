import 'package:projeto_avirario/app/domain/dto/dto_lote.dart';
import 'package:projeto_avirario/app/database/sqlite/conexao.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_lote.dart';

class DAOLote implements IDAOLote {
  @override
  Future<DTOLote> salvar(DTOLote dto) async {
    final db = await Conexao.open();
    if (dto.id == null) {
      dto.id = await db.insert('lote', {
        'dataEntrada': dto.dataEntrada.toIso8601String(),
        'quantidadeAves': dto.quantidadeAves,
        'pesoMedio': dto.pesoMedio,
        'qtdRacaoInicial': dto.qtdRacaoInicial,
      });
    } else {
      await db.update('lote', {
        'dataEntrada': dto.dataEntrada.toIso8601String(),
        'quantidadeAves': dto.quantidadeAves,
        'pesoMedio': dto.pesoMedio,
        'qtdRacaoInicial': dto.qtdRacaoInicial,
      }, where: 'id = ?', whereArgs: [dto.id]);
    }
    return dto;
  }

  @override
  Future<DTOLote?> buscarPorId(dynamic id) async {
    final db = await Conexao.open();
    List<Map<String, dynamic>> result = await db.query('lote', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      final lote = result.first;
      return DTOLote(
        id: lote['id'] as int,
        dataEntrada: DateTime.parse(lote['dataEntrada'] as String),
        quantidadeAves: lote['quantidadeAves'] as int,
        pesoMedio: lote['pesoMedio'] as double,
        qtdRacaoInicial: lote['qtdRacaoInicial'] as double,
      );
    }
    return null;
  }

  @override
  Future<List<DTOLote>> buscarTodos() async {
    final db = await Conexao.open();
    final result = await db.query('lote');
    return result.map((lote) {
      return DTOLote(
        id: lote['id'] as int,
        dataEntrada: DateTime.parse(lote['dataEntrada'] as String),
        quantidadeAves: lote['quantidadeAves'] as int,
        pesoMedio: lote['pesoMedio'] as double,
        qtdRacaoInicial: lote['qtdRacaoInicial'] as double,
      );
    }).toList();
  }

  @override
  Future<void> deletar(dynamic id) async {
    final db = await Conexao.open();
    await db.delete('lote', where: 'id = ?', whereArgs: [id]);
  }
}
