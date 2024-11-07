import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_avirario/app/domain/usuario.dart';
import 'package:projeto_avirario/app/domain/dto/dto_usuario.dart';
import 'package:projeto_avirario/app/domain/propriedade.dart';
import 'package:mockito/mockito.dart';

// Mock da classe Propriedade
class MockPropriedade extends Mock implements Propriedade {}

void main() {
  test('Validação de nome vazio lança exceção', () {
    expect(
      () => Usuario(
          dto: DTOUsuario(nome: '', email: 'usuario@example.com')),
      throwsA(isA<Exception>().having(
          (e) => e.toString(), 'message', contains('Nome não pode ser vazio'))),
    );
  });

  test('Validação de email vazio lança exceção', () {
    expect(
      () => Usuario(
          dto: DTOUsuario(nome: 'Usuario', email: '')),
      throwsA(isA<Exception>().having((e) => e.toString(), 'message',
          contains('Email não pode ser vazio'))),
    );
  });

  test('Validação de email inválido lança exceção', () {
    expect(
      () => Usuario(
          dto: DTOUsuario(nome: 'Usuario', email: 'emailinvalido')),
      throwsA(isA<Exception>().having((e) => e.toString(), 'message',
          contains('Email inválido'))),
    );
  });

  test('Adicionar propriedade à lista de propriedades', () {
    final usuario = Usuario(dto: DTOUsuario(nome: 'Usuario', email: 'usuario@example.com'));
    final propriedade = MockPropriedade();

    usuario.addPropriedade(propriedade);

    expect(usuario.propriedades.length, 1);
  });

  test('Remover propriedade da lista de propriedades', () {
    final usuario = Usuario(dto: DTOUsuario(nome: 'Usuario', email: 'usuario@example.com'));
    final propriedade = MockPropriedade();

    usuario.addPropriedade(propriedade);
    usuario.removePropriedade(0);

    expect(usuario.propriedades.length, 0);
  });

  test('Editar propriedade na lista de propriedades', () {
    final usuario = Usuario(dto: DTOUsuario(nome: 'Usuario', email: 'usuario@example.com'));
    final propriedade1 = MockPropriedade();
    final propriedade2 = MockPropriedade();

    usuario.addPropriedade(propriedade1);
    usuario.editPropriedade(0, propriedade2);

    expect(usuario.propriedades[0], propriedade2);
  });
}
