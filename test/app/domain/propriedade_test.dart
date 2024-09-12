import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_avirario/app/domain/propriedade.dart';
import 'package:projeto_avirario/app/domain/dto/dto_propriedade.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_propriedade.dart';

class MockDAOPropriedade implements IDAOPropriedade {
  List<DTOPropriedade> propriedades = [];

  @override
  Future<DTOPropriedade> salvar(DTOPropriedade dto) async {
    dto.id ??= propriedades.length + 1;
    propriedades.add(dto);
    return dto;
  }

  @override
  Future<void> deletarPropriedade(dynamic id) async {
    propriedades.removeWhere((propriedade) => propriedade.id == id);
  }

  @override
  Future<DTOPropriedade?> buscarPorId(dynamic id) async {
    try {
      return propriedades.firstWhere(
        (propriedade) => propriedade.id == id,
      );
    } catch (e) {
      // Retorna null se não encontrado
      return null;
    }
  }

  @override
  Future<List<DTOPropriedade>> buscarPropriedade() async {
    return propriedades;
  }
}

void main() {
  late MockDAOPropriedade dao;

  setUp(() {
    dao = MockDAOPropriedade();
  });

  test('Salvar propriedade', () async {
    final propriedade = Propriedade(
      dto: DTOPropriedade(
        nome: 'Fazenda 1',
        localizacao: 'Campo',
        qtdAviario: 5,
      ),
    );
    final dtoSalvo = await propriedade.salvar(dao);

    expect(dtoSalvo.id, isNotNull);
    expect((await dao.buscarPropriedade()).length, 1);
  });

  test('Buscar propriedade por ID', () async {
    final propriedade = Propriedade(
      dto: DTOPropriedade(
        nome: 'Fazenda 2',
        localizacao: 'Montanha',
        qtdAviario: 3,
      ),
    );
    final dtoSalvo = await propriedade.salvar(dao);

    final propriedadeBuscada = await Propriedade.buscarPorId(dao, dtoSalvo.id);
    expect(propriedadeBuscada?.nome, 'Fazenda 2');
  });

  test('Deletar propriedade', () async {
    final propriedade = Propriedade(
      dto: DTOPropriedade(
        nome: 'Fazenda 3',
        localizacao: 'Praia',
        qtdAviario: 2,
      ),
    );
    final dtoSalvo = await propriedade.salvar(dao);

    expect(dtoSalvo.id, isNotNull);
    expect((await dao.buscarPropriedade()).length, 1);

    await propriedade.deletarPropriedade(dao);
    expect((await dao.buscarPropriedade()).length, 0);
  });

  test('Nome da propriedade vazio', () {
    expect(
      () async => Propriedade(
        dto: DTOPropriedade(nome: '', localizacao: 'Campo', qtdAviario: 3),
      ),
      throwsA(isA<Exception>().having((e) => e.toString(), 'message',
          contains('Nome da propriedade não pode ser vazio'))),
    );
  });

  test('Localização da propriedade vazia', () {
    expect(
      () async => Propriedade(
        dto: DTOPropriedade(nome: 'Fazenda', localizacao: '', qtdAviario: 3),
      ),
      throwsA(isA<Exception>().having((e) => e.toString(), 'message',
          contains('Localização da propriedade não pode ser vazia'))),
    );
  });

  test('Quantidade de aviários igual ou menor que zero', () {
    expect(
      () async => Propriedade(
        dto: DTOPropriedade(
            nome: 'Fazenda', localizacao: 'Campo', qtdAviario: 0),
      ),
      throwsA(isA<Exception>().having((e) => e.toString(), 'message',
          contains('Quantidade de aviários não pode ser vazia'))),
    );
  });
}
