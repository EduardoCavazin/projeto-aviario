import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:projeto_avirario/app/database/sqlite/conexao.dart'; 
import 'package:projeto_avirario/app/domain/dto/dto_usuario.dart';
import 'package:projeto_avirario/app/database/sqlite/dao_usuario.dart';

void main() async {
  setUpAll(() {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
  });

  late DAOUsuario dao;

  setUp(() async {
    await Conexao.open();
    dao = DAOUsuario();
  });

  test('Salvar e buscar usuário', () async {
    final usuarioDto = DTOUsuario(
      nome: 'Teste User',
      email: 'teste@example.com',
      senha: 'test123',
    );
    final salvo = await dao.salvar(usuarioDto);

    expect(salvo.id, isNotNull);

    final buscado = await dao.buscarPorId(salvo.id);
    expect(buscado, isNotNull);
    expect(buscado!.nome, 'Teste User');
    expect(buscado.email, 'teste@example.com');
  });

  test('Deletar usuário', () async {
    final usuarioDto = DTOUsuario(
      nome: 'User to Delete',
      email: 'delete@example.com',
      senha: 'delete123',
    );
    final salvo = await dao.salvar(usuarioDto);

    await dao.deletar(salvo.id);

    final buscado = await dao.buscarPorId(salvo.id);
    expect(buscado, isNull);
  });

  test('Buscar todos os usuários', () async {
    await dao.salvar(DTOUsuario(
      nome: 'User1',
      email: 'user1@example.com',
      senha: 'password1',
    ));
    await dao.salvar(DTOUsuario(
      nome: 'User2',
      email: 'user2@example.com',
      senha: 'password2',
    ));

    final usuarios = await dao.buscarUsuarios();
    expect(usuarios.length, greaterThanOrEqualTo(2));
  });
}
