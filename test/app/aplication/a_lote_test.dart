import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:projeto_avirario/app/database/firebase/conexao.dart';
import 'package:projeto_avirario/app/domain/dto/dto_lote.dart';
import 'package:projeto_avirario/app/database/firebase/dao_lote.dart';
import 'package:projeto_avirario/app/aplication/a_lote.dart'; 

void main() async {
  late ALote aLote;
  late DAOLote dao;

  setUpAll(() async {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
    await Conexao.open();
  });

  setUp(() async {
    // Limpar dados anteriores
    dao = DAOLote();
    final lotes = await dao.buscarTodos();
    for (var lote in lotes) {
      await dao.deletar(lote.id);
    }
  });

  test('Salvar e buscar lote', () async {
    final dto = DTOLote(
      dataEntrada: DateTime.now(),
      quantidadeAves: 1200,
      pesoMedio: 2.7,
      qtdRacaoInicial: 250,
    );
    aLote = ALote(dao: dao, dto: dto);

    final salvoDto = await aLote.salvarLote();
    expect(salvoDto.id, isNotNull);

    final buscado = await aLote.buscarLotePorId(salvoDto.id);
    expect(buscado, isNotNull);
    expect(buscado!.dto.quantidadeAves, 1200);
    expect(buscado.dto.pesoMedio, 2.7);
    expect(buscado.dto.qtdRacaoInicial, 250);
  });

  test('Deletar lote', () async {
    final dto = DTOLote(
      dataEntrada: DateTime.now(),
      quantidadeAves: 800,
      pesoMedio: 2.3,
      qtdRacaoInicial: 150,
    );
    aLote = ALote(dao: dao, dto: dto);

    final salvoDto = await aLote.salvarLote();
    await aLote.deletarLote();

    final buscado = await aLote.buscarLotePorId(salvoDto.id);
    expect(buscado, isNull);
  });

  test('Buscar todos os lotes', () async {
    final dto1 = DTOLote(
      dataEntrada: DateTime.now(),
      quantidadeAves: 1000,
      pesoMedio: 2.5,
      qtdRacaoInicial: 200,
    );
    final dto2 = DTOLote(
      dataEntrada: DateTime.now(),
      quantidadeAves: 1500,
      pesoMedio: 2.8,
      qtdRacaoInicial: 300,
    );
    aLote = ALote(dao: dao, dto: dto1);
    await aLote.salvarLote();
    aLote = ALote(dao: dao, dto: dto2);
    await aLote.salvarLote();

    final lotes = await aLote.buscarTodosLotes();
    expect(lotes.length, 2);
    expect(lotes.any((lote) => lote.dto.quantidadeAves == 1000), true);
    expect(lotes.any((lote) => lote.dto.quantidadeAves == 1500), true);
  });
}
