import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_avirario/app/domain/lote.dart';
import 'package:projeto_avirario/app/domain/dto/dto_lote.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_lote.dart';

class MockDAOLote implements IDAOLote {
  List<DTOLote> lotes = [];

  @override
  Future<DTOLote> salvar(DTOLote dto) async {
    dto.id ??= lotes.length + 1;
    lotes.add(dto);
    return dto;
  }

  @override
  Future<void> deletar(dynamic id) async {
    lotes.removeWhere((lote) => lote.id == id);
  }

  @override
  Future<DTOLote?> buscarPorId(dynamic id) async {
    try {
      return lotes.firstWhere((lote) => lote.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<DTOLote>> buscarTodos() async {
    return lotes;
  }
}

void main() {
  late MockDAOLote dao;

  setUp(() {
    dao = MockDAOLote();
  });

  test('Salvar lote', () async {
    final lote = Lote(
        dto: DTOLote(
            dataEntrada: DateTime.now(),
            quantidadeAves: 1000,
            pesoMedio: 2.5,
            qtdRacaoInicial: 200));
    final dtoSalvo = await lote.salvar(dao);

    expect(dtoSalvo.id, isNotNull);
    expect((await dao.buscarTodos()).length, 1);
  });

  test('Buscar lote por ID', () async {
    final lote = Lote(
        dto: DTOLote(
            dataEntrada: DateTime.now(),
            quantidadeAves: 1200,
            pesoMedio: 2.7,
            qtdRacaoInicial: 250));
    final dtoSalvo = await lote.salvar(dao);

    final loteBuscado = await Lote.buscarPorId(dao, dtoSalvo.id);
    expect(loteBuscado?.quantidadeAves, 1200);
  });

  test('Deletar lote', () async {
    final lote = Lote(
        dto: DTOLote(
            dataEntrada: DateTime.now(),
            quantidadeAves: 800,
            pesoMedio: 2.3,
            qtdRacaoInicial: 150));
    final dtoSalvo = await lote.salvar(dao);

    expect(dtoSalvo.id, isNotNull);

    await lote.deletar(dao);

    // Verificar se o lote foi realmente deletado
    final loteDeletado = await dao.buscarPorId(dtoSalvo.id);
    expect(loteDeletado, isNull);
  });

  test('Validar quantidade de aves', () {
    expect(
        () => Lote(
                dto: DTOLote(
                    dataEntrada: DateTime.now(),
                    quantidadeAves: 10000,
                    pesoMedio: 2.5,
                    qtdRacaoInicial: 200))
            .qtdAvesVazia(),
        throwsException);
  });

  test('Validar peso médio', () {
    expect(
        () => Lote(
                dto: DTOLote(
                    dataEntrada: DateTime.now(),
                    quantidadeAves: 15000,
                    pesoMedio: 0,
                    qtdRacaoInicial: 200))
            .pesoMedioVazio(),
        throwsException);
  });

  test('Validar quantidade de ração inicial', () {
    expect(
        () => Lote(
                dto: DTOLote(
                    dataEntrada: DateTime.now(),
                    quantidadeAves: 15000,
                    pesoMedio: 2.5,
                    qtdRacaoInicial: 0))
            .qtdRacaoInicialVazia(),
        throwsException);
  });
}
