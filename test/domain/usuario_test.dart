import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_avirario/domain/usuario.dart';
import 'package:projeto_avirario/domain/dto/dto_usuario.dart';
import 'package:projeto_avirario/domain/interface/i_dao_usuario.dart';

class MockDAOUsuario implements IDAOUsuario {
  List<DTOUsuario> usuarios = [];

  @override
  DTOUsuario salvar(DTOUsuario dto) {
    dto.id ??= usuarios.length + 1;
    usuarios.add(dto);
    return dto;
  }

  @override
  void deletar(dynamic id) {
    usuarios.removeWhere((usuario) => usuario.id == id);
  }

  @override
  DTOUsuario buscarPorId(dynamic id) {
    return usuarios.firstWhere((usuario) => usuario.id == id, orElse: () {
      throw Exception('Usuario not found');
    });
  }

  @override
  List<DTOUsuario> buscarUsuarios() {
    return usuarios;
  }
}

void main() {
  late MockDAOUsuario dao;

  setUp(() {
    dao = MockDAOUsuario();
  });

  test('Salvar usuario', () {
    final usuario = Usuario(
        dto: DTOUsuario(
            nome: 'João', email: 'joao@example.com', senha: '123456'));
    final dtoSalvo = usuario.salvar(dao);

    expect(dtoSalvo.id, isNotNull);
    expect(dao.buscarUsuarios().length, 1);
  });

  test('Buscar usuario por ID', () {
    final usuario = Usuario(
        dto: DTOUsuario(
            nome: 'Maria', email: 'maria@example.com', senha: 'abcdef'));
    final dtoSalvo = usuario.salvar(dao);

    final usuarioBuscado = dao.buscarPorId(dtoSalvo.id);
    expect(usuarioBuscado.nome, 'Maria');
  });

  test('Deletar usuario', () {
    final usuario = Usuario(
        dto: DTOUsuario(
            nome: 'Carlos', email: 'carlos@example.com', senha: '123abc'));
    final dtoSalvo = usuario.salvar(dao);

    expect(dtoSalvo.id, isNotNull);

    dao.deletar(dtoSalvo.id);
    expect(dao.buscarUsuarios().length, 0);
  });

  test('Nome vazio deve lançar exceção', () {
    expect(
      () => Usuario(
          dto:
              DTOUsuario(nome: '', email: 'joao@example.com', senha: '123456')),
      throwsA(isA<Exception>().having(
          (e) => e.toString(), 'message', contains('Nome não pode ser vazio'))),
    );
  });

  test('Email vazio deve lançar exceção', () {
    expect(
      () => Usuario(dto: DTOUsuario(nome: 'João', email: '', senha: '123456')),
      throwsA(isA<Exception>().having((e) => e.toString(), 'message',
          contains('Email não pode ser vazio'))),
    );
  });

  test('Senha vazia deve lançar exceção', () {
    expect(
      () => Usuario(
          dto: DTOUsuario(nome: 'João', email: 'joao@example.com', senha: '')),
      throwsA(isA<Exception>().having((e) => e.toString(), 'message',
          contains('Senha não pode ser vazia'))),
    );
  });
}
