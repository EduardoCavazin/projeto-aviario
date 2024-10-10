import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:projeto_avirario/app/database/sqlite/conexao.dart';
import 'package:projeto_avirario/app/domain/dto/dto_aviario.dart';
import 'package:projeto_avirario/app/database/sqlite/dao_aviario.dart';
import 'package:projeto_avirario/app/application/a_aviario.dart';

void main() async {
  late AAviario aAviario;
  late DAOAviario dao;

  setUpAll(() async {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
    await Conexao.open();
  });

  setUp(() async {
    dao = DAOAviario();
    final aviarios = await dao.buscarTodos();
    for (var aviario in aviarios) {
      await dao.deletar(aviario.id);
    }
  });

  test('Salvar e buscar aviario', () async {
    final dto = DTOAviario(
      nome: 'Aviário Teste',
      capacidade: 5000,
    );
    aAviario = AAviario(dao: dao, dto: dto);

    final salvoDto = await aAviario.salvarAviario();
    expect(salvoDto.id, isNotNull);

    final buscado = await AAviario.buscarAviarioPorId(dao, salvoDto.id);
    expect(buscado, isNotNull);
    expect(buscado!.dto.nome, 'Aviário Teste');
    expect(buscado.dto.capacidade, 5000);
  });

  test('Deletar aviario', () async {
    final dto = DTOAviario(
      nome: 'Aviário Para Deletar',
      capacidade: 3000,
    );
    aAviario = AAviario(dao: dao, dto: dto);

    final salvoDto = await aAviario.salvarAviario();
    await aAviario.deletarAviario();

    final buscado = await AAviario.buscarAviarioPorId(dao, salvoDto.id);
    expect(buscado, isNull);
  });

  test('Buscar todos os aviarios', () async {
    final dto1 = DTOAviario(
      nome: 'Aviário 1',
      capacidade: 10000,
    );
    final dto2 = DTOAviario(
      nome: 'Aviário 2',
      capacidade: 15000,
    );
    aAviario = AAviario(dao: dao, dto: dto1);
    await aAviario.salvarAviario();
    aAviario = AAviario(dao: dao, dto: dto2);
    await aAviario.salvarAviario();

    final aviarios = await AAviario.buscarTodosAviarios(dao);
    expect(aviarios.length, 2);
    expect(aviarios.any((aviario) => aviario.dto.nome == 'Aviário 1'), true);
    expect(aviarios.any((aviario) => aviario.dto.nome == 'Aviário 2'), true);
  });
}
