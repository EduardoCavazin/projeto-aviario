import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_avirario/app/aplication/a_aviario.dart';
import 'package:projeto_avirario/app/domain/dto/dto_aviario.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_aviario.dart';

class MockDAOAviario implements IDAOAviario {
  List<DTOAviario> aviarios = [];

  @override
  Future<DTOAviario> salvar(DTOAviario dto) async {
    dto.id ??= aviarios.length + 1;
    aviarios.add(dto);
    return dto;
  }

  @override
  Future<void> deletar(dynamic id) async {
    aviarios.removeWhere((aviario) => aviario.id == id);
  }

  @override
  Future<DTOAviario?> buscarPorId(dynamic id) async {
    try {
      return aviarios.firstWhere((aviario) => aviario.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<DTOAviario>> buscarTodos() async {
    return aviarios;
  }
}

void main() {
  group('Teste da Classe Aviario', () {
    late MockDAOAviario dao;

    setUp(() {
      dao = MockDAOAviario();
    });

    test('Salvar aviario', () async {
      final aviario = AAviario(
        dao: dao,
        dto: DTOAviario(nome: 'Aviário 1', capacidade: 2000),
      );
      final dtoSalvo = await aviario.salvarAviario();

      expect(dtoSalvo.id, isNotNull);
      expect((await dao.buscarTodos()).length, 1);
    });

    test('Buscar aviario por ID', () async {
      final aviario = AAviario(
        dao: dao,
        dto: DTOAviario(nome: 'Aviário 2', capacidade: 2500),
      );
      final dtoSalvo = await aviario.salvarAviario();

      final aviarioBuscado = await AAviario.buscarAviarioPorId(dao, dtoSalvo.id);
      expect(aviarioBuscado?.dto.nome, 'Aviário 2');
    });

    test('Deletar aviario', () async {
      final aviario = AAviario(
        dao: dao,
        dto: DTOAviario(nome: 'Aviário 3', capacidade: 3000),
      );
      final dtoSalvo = await aviario.salvarAviario();

      expect(dtoSalvo.id, isNotNull);

      await aviario.deletarAviario();

      final todosAviarios = await dao.buscarTodos();
      expect(todosAviarios.isEmpty, isTrue);
    });
  });
}
