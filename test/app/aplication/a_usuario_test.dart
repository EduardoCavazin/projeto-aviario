import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:projeto_avirario/app/database/sqlite/conexao.dart';
import 'package:projeto_avirario/app/domain/dto/dto_usuario.dart';
import 'package:projeto_avirario/app/database/sqlite/dao_usuario.dart';
import 'package:projeto_avirario/app/aplication/a_usuario.dart';

void main() async {
  late AUsuario aUsuario;

  setUpAll(() async {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
    await Conexao.open();
  });

  setUp(() async {
    // Limpar dados anteriores
    final dao = DAOUsuario();
    final usuarios = await dao.buscarUsuarios();
    for (var usuario in usuarios) {
      await dao.deletar(usuario.id);
    }
  });

  test('Salvar e buscar usuário', () async {
    final dto = DTOUsuario(
      nome: 'Teste User',
      email: 'teste@example.com',
      senha: 'test123',
    );
    aUsuario = AUsuario(dto: dto);

    final salvoDto = await aUsuario.salvar();
    expect(salvoDto.id, isNotNull);

    final buscado = await AUsuario.buscarPorId(salvoDto.id);
    expect(buscado, isNotNull);
    expect(buscado!.nome, 'Teste User');
    expect(buscado.email, 'teste@example.com');
    expect(buscado.senha, 'test123');
  });

  test('Deletar usuário', () async {
    final dto = DTOUsuario(
      nome: 'User to Delete',
      email: 'delete@example.com',
      senha: 'delete123',
    );
    aUsuario = AUsuario(dto: dto);

    final salvoDto = await aUsuario.salvar();
    await aUsuario.deletar();

    final buscado = await AUsuario.buscarPorId(salvoDto.id);
    expect(buscado, isNull);
  });

  test('Buscar todos os usuários', () async {
    final dto1 = DTOUsuario(
      nome: 'User1',
      email: 'user1@example.com',
      senha: 'password1',
    );
    final dto2 = DTOUsuario(
      nome: 'User2',
      email: 'user2@example.com',
      senha: 'password2',
    );
    aUsuario = AUsuario(dto: dto1);
    await aUsuario.salvar();
    aUsuario = AUsuario(dto: dto2);
    await aUsuario.salvar();

    final usuarios = await AUsuario.buscarUsuarios();
    expect(usuarios.length, 2);
    expect(usuarios.any((usuario) => usuario.nome == 'User1'), true);
    expect(usuarios.any((usuario) => usuario.nome == 'User2'), true);
  });
}
