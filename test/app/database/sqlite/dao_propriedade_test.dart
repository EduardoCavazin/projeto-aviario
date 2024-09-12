import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:projeto_avirario/app/database/sqlite/conexao.dart'; 
import 'package:projeto_avirario/app/database/sqlite/dao_propriedade.dart';
import 'package:projeto_avirario/app/domain/dto/dto_propriedade.dart';

void main() async {
  setUpAll(() {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
  });

  setUp(() async {
    await Conexao.open();
  });

  test('Salvar e buscar propriedade', () async {
    final dao = DAOPropriedade();
    final dtoPropriedade = DTOPropriedade(
      nome: 'Propriedade Teste',
      localizacao: 'Localização Teste',
      qtdAviario: 5,
    );
    final salvo = await dao.salvar(dtoPropriedade);

    expect(salvo.id, isNotNull);

    final buscado = await dao.buscarPorId(salvo.id);
    expect(buscado, isNotNull);
    expect(buscado!.nome, 'Propriedade Teste');
    expect(buscado.localizacao, 'Localização Teste');
  });

  test('Deletar propriedade', () async {
    final dao = DAOPropriedade();
    final dtoPropriedade = DTOPropriedade(
      nome: 'Propriedade Para Deletar',
      localizacao: 'Localização Para Deletar',
      qtdAviario: 3,
    );
    final salvo = await dao.salvar(dtoPropriedade);

    await dao.deletarPropriedade(salvo.id);

    final buscado = await dao.buscarPorId(salvo.id);
    expect(buscado, isNull);
  });

  test('Buscar todas as propriedades', () async {
    final dao = DAOPropriedade();
    await dao.salvar(DTOPropriedade(
      nome: 'Propriedade 1',
      localizacao: 'Localização 1',
      qtdAviario: 5,
    ));
    await dao.salvar(DTOPropriedade(
      nome: 'Propriedade 2',
      localizacao: 'Localização 2',
      qtdAviario: 10,
    ));

    final propriedades = await dao.buscarPropriedade();
    expect(propriedades.length, greaterThanOrEqualTo(2));
  });
}
