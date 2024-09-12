import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_avirario/app/domain/aviario.dart';
import 'package:projeto_avirario/app/domain/dto/dto_aviario.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_aviario.dart';

class MockDAOAviario implements IDAOAviario {
  List<DTOAviario> aviarios = [];

  @override
  DTOAviario salvar(DTOAviario dto) {
    dto.id ??= aviarios.length + 1;
    aviarios.add(dto);
    return dto;
  }

  @override
  void deletar(dynamic id) {
    aviarios.removeWhere((aviario) => aviario.id == id);
  }

  @override
  DTOAviario? buscarPorId(dynamic id) {
    return aviarios.firstWhere((aviario) => aviario.id == id, orElse: () {
      throw Exception('Aviário não encontrado');
    });
  }

  @override
  List<DTOAviario> buscarTodos() {
    return aviarios;
  }
}

void main() {
  group('Teste da Classe Aviario', () {
    final dao = MockDAOAviario();

    test('Salvar aviario', () {
      final aviario = Aviario(dto: DTOAviario(nome: 'Aviário 1', capacidade: 2000));
      final dtoSalvo = aviario.salvar(dao);

      expect(dtoSalvo.id, isNotNull);
      expect(dao.buscarTodos().length, 1);
    });

    test('Buscar aviario por ID', () {
      final aviario = Aviario(dto: DTOAviario(nome: 'Aviário 2', capacidade: 2500));
      final dtoSalvo = aviario.salvar(dao);

      final aviarioBuscado = Aviario.buscarPorId(dao, dtoSalvo.id);
      expect(aviarioBuscado?.nome, 'Aviário 2');
    });

    test('Deletar aviario', () {
      final aviario = Aviario(dto: DTOAviario(nome: 'Aviário 3', capacidade: 3000));
      final dtoSalvo = aviario.salvar(dao);

      expect(dtoSalvo.id, isNotNull);

      aviario.deletar(dao);
    });
  });
}
