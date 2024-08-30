import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_avirario/domain/propriedade.dart';
import 'package:projeto_avirario/domain/dto/dto_propriedade.dart';
import 'package:projeto_avirario/domain/interface/i_dao_propriedade.dart';

class MockDAOPropriedade implements IDAOPropriedade {
  List<DTOPropriedade> propriedades = [];

  @override
  DTOPropriedade salvar(DTOPropriedade dto) {
    dto.id ??= propriedades.length + 1;
    propriedades.add(dto);
    return dto;
  }

  @override
  void deletarPropriedade(dynamic id) {
    propriedades.removeWhere((propriedade) => propriedade.id == id);
  }

  @override
  DTOPropriedade? buscarPorId(dynamic id) {
    return propriedades.firstWhere(
      (propriedade) => propriedade.id == id,
      orElse: () {
        throw Exception('Propriedade não encontrada');
      });  // Retorna null se não encontrado
  }

  @override
  List<DTOPropriedade> buscarPropriedade() {
    return propriedades;
  }
}

void main() {
  late MockDAOPropriedade dao;

  setUp(() {
    dao = MockDAOPropriedade();
  });

  test('Salvar propriedade', () {
    final propriedade = Propriedade(
      dto: DTOPropriedade(
        nome: 'Fazenda 1',
        localizacao: 'Campo',
        qtdAviario: 5,
      ),
    );
    final dtoSalvo = propriedade.salvar(dao);

    expect(dtoSalvo.id, isNotNull);
    expect(dao.buscarPropriedade().length, 1);
  });

  test('Buscar propriedade por ID', () {
    final propriedade = Propriedade(
      dto: DTOPropriedade(
        nome: 'Fazenda 2',
        localizacao: 'Montanha',
        qtdAviario: 3,
      ),
    );
    final dtoSalvo = propriedade.salvar(dao);

    final propriedadeBuscada = Propriedade.buscarPorId(dao, dtoSalvo.id);
    expect(propriedadeBuscada?.nome, 'Fazenda 2');
  });

  test('Deletar propriedade', () {
    final propriedade = Propriedade(
      dto: DTOPropriedade(
        nome: 'Fazenda 3',
        localizacao: 'Praia',
        qtdAviario: 2,
      ),
    );
    final dtoSalvo = propriedade.salvar(dao);

    expect(dtoSalvo.id, isNotNull);
    expect(dao.buscarPropriedade().length, 1);

    propriedade.deletarPropriedade(dao);
  });
}
