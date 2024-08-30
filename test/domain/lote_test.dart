import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_avirario/domain/lote.dart';
import 'package:projeto_avirario/domain/dto/dto_lote.dart';
import 'package:projeto_avirario/domain/interface/i_dao_lote.dart';

class MockDAOLote implements IDAOLote {
  List<DTOLote> lotes = [];

  @override
  DTOLote salvar(DTOLote dto) {
    dto.id ??= lotes.length + 1;
    lotes.add(dto);
    return dto;
  }

  @override
  void deletar(dynamic id) {
    lotes.removeWhere((lote) => lote.id == id);
  }

  @override
  DTOLote? buscarPorId(dynamic id) {
    return lotes.firstWhere((lote) => lote.id == id, orElse: () {
      throw Exception('Lote não encontrado');
    });
  }

  @override
  List<DTOLote> buscarTodos() {
    return lotes;
  }
}

void main() {

  late MockDAOLote dao;

  setUp(() {
    dao = MockDAOLote();
  });

  test('Salvar lote', () {
    final lote = Lote(
        dto: DTOLote(
            dataEntrada: DateTime.now(),
            quantidadeAves: 1000,
            pesoMedio: 2.5,
            qtdRacaoInicial: 200));
    final dtoSalvo = lote.salvar(dao);

    expect(dtoSalvo.id, isNotNull);
    expect(dao.buscarTodos().length, 1);
  });

  test('Buscar lote por ID', () {
    final lote = Lote(
        dto: DTOLote(
            dataEntrada: DateTime.now(),
            quantidadeAves: 1200,
            pesoMedio: 2.7,
            qtdRacaoInicial: 250));
    final dtoSalvo = lote.salvar(dao);

    final loteBuscado = Lote.buscarPorId(dao, dtoSalvo.id);
    expect(loteBuscado?.quantidadeAves, 1200);
  });

  test('Deletar lote', () {
    final lote = Lote(
        dto: DTOLote(
            dataEntrada: DateTime.now(),
            quantidadeAves: 800,
            pesoMedio: 2.3,
            qtdRacaoInicial: 150));
    final dtoSalvo = lote.salvar(dao);

    expect(dtoSalvo.id, isNotNull);

    lote.deletar(dao);
  });
}
