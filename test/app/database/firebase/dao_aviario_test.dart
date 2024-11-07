import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:projeto_avirario/app/database/firebase/conexao.dart';
import 'package:projeto_avirario/app/database/firebase/dao_aviario.dart';
import 'package:projeto_avirario/app/domain/dto/dto_aviario.dart';

void main() async {
  setUpAll(() {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
  });

  setUp(() async {
    await Conexao.open();
  });

  test('Salvar e buscar aviário', () async {
    final dao = DAOAviario();
    final dtoAviario = DTOAviario(
      nome: 'Aviário Teste',
      capacidade: 5000,
    );
    final salvo = await dao.salvar(dtoAviario);

    expect(salvo.id, isNotNull);

    final buscado = await dao.buscarPorId(salvo.id);
    expect(buscado, isNotNull);
    expect(buscado!.nome, 'Aviário Teste');
    expect(buscado.capacidade, 5000);
  });

  test('Deletar aviário', () async {
    final dao = DAOAviario();
    final dtoAviario = DTOAviario(
      nome: 'Aviário Para Deletar',
      capacidade: 4000,
    );
    final salvo = await dao.salvar(dtoAviario);

    await dao.deletar(salvo.id);

    final buscado = await dao.buscarPorId(salvo.id);
    expect(buscado, isNull);
  });

  test('Buscar todos os aviários', () async {
    final dao = DAOAviario();
    await dao.salvar(DTOAviario(
      nome: 'Aviário 1',
      capacidade: 3000,
    ));
    await dao.salvar(DTOAviario(
      nome: 'Aviário 2',
      capacidade: 6000,
    ));

    final aviarios = await dao.buscarTodos();
    expect(aviarios.length, greaterThanOrEqualTo(2));
  });
}
