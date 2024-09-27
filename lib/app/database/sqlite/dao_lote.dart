import 'package:projeto_avirario/app/domain/dto/dto_lote.dart';
import 'package:projeto_avirario/app/database/sqlite/conexao.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_lote.dart';
import 'package:sqflite/sqflite.dart';

class DAOLote implements IDAOLote {
  late Database _db;

  Future<void> _openDatabase() async {
    _db = await Conexao.open();
  }

  @override
  Future<DTOLote> salvar(DTOLote dto) async {
    await _openDatabase();

    if(dto.id == null){
        final id = await _db.insert(
          'lote',
          {
            'dataEntrada': dto.dataEntrada.toIso8601String(),
            'quantidadeAves': dto.quantidadeAves,
            'pesoMedio': dto.pesoMedio,
            'qtdRacaoInicial': dto.qtdRacaoInicial,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        return DTOLote(
          id: id,
          dataEntrada: dto.dataEntrada,
          quantidadeAves: dto.quantidadeAves,
          pesoMedio: dto.pesoMedio,
          qtdRacaoInicial: dto.qtdRacaoInicial,
        );
    } else {
      await _db.update(
        'lote',
        {
          'dataEntrada': dto.dataEntrada.toIso8601String(),
          'quantidadeAves': dto.quantidadeAves,
          'pesoMedio': dto.pesoMedio,
          'qtdRacaoInicial': dto.qtdRacaoInicial,
        },
        where: 'id = ?',
        whereArgs: [dto.id],
      );
      return dto;
    }
  }

  @override
  Future<DTOLote?> buscarPorId(dynamic id) async {
    await _openDatabase();
    List<Map<String, dynamic>> maps = await _db.query('lote', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      final lote = maps.first;
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
    await _openDatabase();
    final result = await _db.query('lote');
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
    await _openDatabase();
    await _db.delete('lote', where: 'id = ?', whereArgs: [id]);
  }
}
