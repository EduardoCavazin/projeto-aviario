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
            quantidadeAves: 20000,
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
            quantidadeAves: 25000,
            pesoMedio: 2.7,
            qtdRacaoInicial: 250));
    final dtoSalvo = await lote.salvar(dao);

    final loteBuscado = await Lote.buscarPorId(dao, dtoSalvo.id);
    expect(loteBuscado?.quantidadeAves, 25000);
  });

  test('Deletar lote', () async {
    final lote = Lote(
      dto: DTOLote(
        dataEntrada: DateTime.now(),
        quantidadeAves: 18000,
        pesoMedio: 2.3,
        qtdRacaoInicial: 150,
      ),
    );

    final dtoSalvo = await lote.salvar(dao);

    expect(dtoSalvo.id, isNotNull);
    expect((await dao.buscarTodos()).length, 1);

    await dao.deletar(dtoSalvo.id); // Passando o DAO ao método deletar
    expect((await dao.buscarTodos()).length, 0);
  });

  test('Validar quantidade minima de aves', () {
    expect(
        () => Lote(
                dto: DTOLote(
                    dataEntrada: DateTime.now(),
                    quantidadeAves: 1000,
                    pesoMedio: 2.5,
                    qtdRacaoInicial: 200))
            .validarQtdAves(),
        throwsException);
  });

  test('Validar quantidade maxima de aves', () {
    expect(
        () => Lote(
                dto: DTOLote(
                    dataEntrada: DateTime.now(),
                    quantidadeAves: 1000000,
                    pesoMedio: 2.5,
                    qtdRacaoInicial: 200))
            .validarQtdAves(),
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
            .validarPesoMedio(),
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
            .validarQtdRacao(),
        throwsException);
  });
}
