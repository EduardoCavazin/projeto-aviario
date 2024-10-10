import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_avirario/app/domain/usuario.dart';
import 'package:projeto_avirario/app/domain/dto/dto_usuario.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_usuario.dart';

class MockDAOUsuario implements IDAOUsuario {
  List<DTOUsuario> usuarios = [];

  @override
  Future<DTOUsuario> salvar(DTOUsuario dto) async {
    dto.id ??= usuarios.length + 1;
    usuarios.add(dto);
    return dto;
  }

  @override
  Future<void> deletar(dynamic id) async {
    usuarios.removeWhere((usuario) => usuario.id == id);
  }

  @override
  Future<DTOUsuario?> buscarPorId(dynamic id) async {
    try {
      return usuarios.firstWhere((usuario) => usuario.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<DTOUsuario>> buscarUsuarios() async {
    return usuarios;
  }
  
  @override
  Future<DTOUsuario?> buscarPorEmail(String email) {
    // TODO: implement buscarPorEmail
    throw UnimplementedError();
  }
}

void main() {
  late MockDAOUsuario dao;

  setUp(() {
    dao = MockDAOUsuario();
  });

  tearDown(() {
    dao.usuarios.clear();
  });

  test('Salvar usuario', () async {
    final usuario = Usuario(
        dto: DTOUsuario(
            nome: 'João', email: 'joao@example.com', senha: '123456d'));
    final dtoSalvo = await usuario.salvar(dao);

    expect(dtoSalvo.id, isNotNull);
    expect((await dao.buscarUsuarios()).length, 1);
  });

  test('Buscar usuario por ID', () async {
    final usuario = Usuario(
        dto: DTOUsuario(
            nome: 'Maria', email: 'maria@example.com', senha: '1abcdef'));
    final dtoSalvo = await usuario.salvar(dao);

    final usuarioBuscado = await dao.buscarPorId(dtoSalvo.id);
    expect(usuarioBuscado?.nome, 'Maria');
  });

  test('Deletar usuario', () async {
    final usuario = Usuario(
        dto: DTOUsuario(
            nome: 'Carlos', email: 'carlos@example.com', senha: '123abc'));
    final dtoSalvo = await usuario.salvar(dao);

    expect(dtoSalvo.id, isNotNull);

    await dao.deletar(dtoSalvo.id);
    expect((await dao.buscarUsuarios()).length, 0);
  });

  test('Nome vazio deve lançar exceção', () {
    expect(
      () => Usuario(
          dto: DTOUsuario(
              nome: '', email: 'joao@example.com', senha: '123456d')),
      throwsA(isA<Exception>().having(
          (e) => e.toString(), 'message', contains('Nome não pode ser vazio'))),
    );
  });

  test('Email vazio deve lançar exceção', () {
    expect(
      () => Usuario(dto: DTOUsuario(nome: 'João', email: '', senha: '123456d')),
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

  test('Email inválido deve lançar exceção', () {
    expect(
      () => Usuario(
          dto: DTOUsuario(
              nome: 'João', email: 'joaoexample.com', senha: '123456')),
      throwsA(isA<Exception>()
          .having((e) => e.toString(), 'message', contains('Email inválido'))),
    );
  });

  group('Testes Senhas inválidas', () {
    test('Senha menor que 6 caracteres deve lançar exceção', () {
      expect(
        () => Usuario(
            dto: DTOUsuario(nome: 'João', email: 'joao@joao', senha: '12345')),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message',
            contains('Senha deve ter no mínimo 6 caracteres'))),
      );
    });

    test('Senha sem um número deve lançar exceção', () {
      expect(
        () => Usuario(
            dto: DTOUsuario(nome: 'João', email: 'joao@joao', senha: 'abcdef')),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message',
            contains('Senha deve conter pelo menos um caractere e um número'))),
      );
    });

    test('Senha sem um caractere deve lançar exceção', () {
      expect(
        () => Usuario(
            dto: DTOUsuario(nome: 'João', email: 'joao@joao', senha: '123456')),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message',
            contains('Senha deve conter pelo menos um caractere e um número'))),
      );
    });
  });
}
