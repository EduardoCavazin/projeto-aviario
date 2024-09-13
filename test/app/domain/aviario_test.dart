import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_avirario/app/aplication/a_aviario.dart';
import 'package:projeto_avirario/app/domain/aviario.dart';
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

      final aviarioBuscado = await dao.buscarPorId(dtoSalvo.id);
      expect(aviarioBuscado?.nome, 'Aviário 2');
    });

    test('Deletar aviario', () async {
      final aviario = AAviario(
        dao: dao,
        dto: DTOAviario(nome: 'Aviário 3', capacidade: 3000),
      );
      final dtoSalvo = await aviario.salvarAviario();

      expect(dtoSalvo.id, isNotNull);

      await dao.deletar(dtoSalvo.id);

      final todosAviarios = await dao.buscarTodos();
      expect(todosAviarios.isEmpty, isTrue);
    });
  });

  group('Teste regras de negócio', (){

    test('Nome do aviário não pode ser vazio', () {
      expect(
        () => Aviario(dto: DTOAviario(nome: '', capacidade: 2000)), 
        throwsA(isA<Exception>().having(
          (e) => e.toString(), 'message', contains('Nome do aviário não pode ser vazio')))
        );
    });

    test('Capacidade do aviário não pode ser menor que 18000', () {
      expect(
        () => Aviario(dto: DTOAviario(nome: 'Aviário 4', capacidade: 15000)), 
        throwsA(isA<Exception>().having(
          (e) => e.toString(), 'message', contains('Quantidade de aves deve estar entre 18k e 80k')))
        );
    });

    test('Capacidade do aviário não pode ser maior que 80000', () {
      expect(
        () => Aviario(dto: DTOAviario(nome: 'Aviário 5', capacidade: 81000)), 
        throwsA(isA<Exception>().having(
          (e) => e.toString(), 'message', contains('Quantidade de aves deve estar entre 18k e 80k')))
        );
    });

  });
}
