import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:projeto_avirario/app/database/sqlite/conexao.dart';
import 'package:projeto_avirario/app/database/sqlite/dao_lote.dart';
import 'package:projeto_avirario/app/domain/dto/dto_lote.dart';

void main() async {
  setUpAll(() {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
  });

  setUp(() async {
    final db = await Conexao.open();
    await db.execute('DELETE FROM lote'); 
  });

  test('Salvar e buscar lote', () async {
    final dao = DAOLote();
    final dtoLote = DTOLote(
      dataEntrada: DateTime.parse('2024-09-01'), 
      quantidadeAves: 22000,
      pesoMedio: 2.6,
      qtdRacaoInicial: 550.0,
    );
    final salvo = await dao.salvar(dtoLote);

    expect(salvo.id, isNotNull);

    final buscado = await dao.buscarPorId(salvo.id);
    expect(buscado, isNotNull);
    expect(buscado!.dataEntrada, DateTime.parse('2024-09-01'));
    expect(buscado.quantidadeAves, 22000);
    expect(buscado.pesoMedio, 2.6);
    expect(buscado.qtdRacaoInicial, 550.0);
  });

  test('Deletar lote', () async {
    final dao = DAOLote();
    final dtoLote = DTOLote(
      dataEntrada: DateTime.parse('2024-10-01'), 
      quantidadeAves: 18000,
      pesoMedio: 2.4,
      qtdRacaoInicial: 500.0,
    );
    final salvo = await dao.salvar(dtoLote);

    await dao.deletar(salvo.id);

    final buscado = await dao.buscarPorId(salvo.id);
    expect(buscado, isNull);
  });

  test('Buscar todos os lotes', () async {
    final dao = DAOLote();
    await dao.salvar(DTOLote(
      dataEntrada: DateTime.parse('2024-11-01'), 
      quantidadeAves: 20000,
      pesoMedio: 2.5,
      qtdRacaoInicial: 520.0,
    ));
    await dao.salvar(DTOLote(
      dataEntrada: DateTime.parse('2024-12-01'),
      quantidadeAves: 21000,
      pesoMedio: 2.7,
      qtdRacaoInicial: 580.0,
    ));

    final lotes = await dao.buscarTodos();
    expect(lotes.length, greaterThanOrEqualTo(2));
    expect(lotes.map((l) => l.dataEntrada).toList(), containsAll([
      DateTime.parse('2024-11-01'),
      DateTime.parse('2024-12-01'),
    ]));
  });
}
