import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:projeto_avirario/app/database/sqlite/conexao.dart';
import 'package:projeto_avirario/app/domain/dto/dto_propriedade.dart';
import 'package:projeto_avirario/app/database/sqlite/dao_propriedade.dart';
import 'package:projeto_avirario/app/aplication/a_propriedade.dart';

void main() async {
  late APropriedade aPropriedade;

  setUpAll(() async {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
    await Conexao.open();
  });

  setUp(() async {
    final dao = DAOPropriedade();
    final propriedades = await dao.buscarPropriedade();
    for (var propriedade in propriedades) {
      await dao.deletarPropriedade(propriedade.id);
    }
  });

  test('Salvar e buscar propriedade', () async {
    final dto = DTOPropriedade(
      nome: 'Propriedade Teste',
      localizacao: 'Localização Teste',
      qtdAviario: 5,
    );
    aPropriedade = APropriedade(dto: dto);

    final salvoDto = await aPropriedade.salvar();
    expect(salvoDto.id, isNotNull);

    final buscado = await APropriedade.buscarPorId(salvoDto.id);
    expect(buscado, isNotNull);
    expect(buscado!.nome, 'Propriedade Teste');
    expect(buscado.localizacao, 'Localização Teste');
    expect(buscado.qtdAviario, 5);
  });

  test('Deletar propriedade', () async {
    final dto = DTOPropriedade(
      nome: 'Propriedade a Deletar',
      localizacao: 'Localização Deletar',
      qtdAviario: 3,
    );
    aPropriedade = APropriedade(dto: dto);

    final salvoDto = await aPropriedade.salvar();
    await aPropriedade.deletar();

    final buscado = await APropriedade.buscarPorId(salvoDto.id);
    expect(buscado, isNull);
  });

  test('Buscar todas as propriedades', () async {
    final dto1 = DTOPropriedade(
      nome: 'Propriedade 1',
      localizacao: 'Localização 1',
      qtdAviario: 7,
    );
    final dto2 = DTOPropriedade(
      nome: 'Propriedade 2',
      localizacao: 'Localização 2',
      qtdAviario: 10,
    );
    aPropriedade = APropriedade(dto: dto1);
    await aPropriedade.salvar();
    aPropriedade = APropriedade(dto: dto2);
    await aPropriedade.salvar();

    final propriedades = await APropriedade.buscarPropriedades();
    expect(propriedades.length, 2);
    expect(propriedades.any((propriedade) => propriedade.nome == 'Propriedade 1'), true);
    expect(propriedades.any((propriedade) => propriedade.nome == 'Propriedade 2'), true);
  });
}
