import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_ddm/app/domain/user.dart';
import 'package:projeto_ddm/app/domain/property.dart';

void main() {
  group('User', () {
    test('Deve criar um usuário com dados válidos', () {
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'johndoe@example.com',
      );
      expect(user.name, 'John Doe');
      expect(user.email, 'johndoe@example.com');
      expect(user.properties, isEmpty); 
    });

    test('Deve lançar exceção se o nome estiver vazio', () {
      expect(
        () => User(id: '1', name: '', email: 'johndoe@example.com'),
        throwsA(isA<Exception>()),
      );
    });

    test('Deve lançar exceção se o e-mail estiver vazio', () {
      expect(
        () => User(id: '1', name: 'John Doe', email: ''),
        throwsA(isA<Exception>()),
      );
    });

    test('Deve lançar exceção para e-mail inválido', () {
      expect(
        () => User(id: '1', name: 'John Doe', email: 'johndoewrongemail.com'),
        throwsA(isA<Exception>()),
      );
    });

    test('Deve adicionar uma propriedade ao usuário', () {
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'johndoe@example.com',
      );

      final property = Property(
        id: '1',
        name: 'Farm A',
        location: 'Location A',
        aviaryCount: 2,
      );

      user.addProperty(property);

      expect(user.properties.length, 1);
      expect(user.properties.first.name, 'Farm A');
    });

    test('Deve remover uma propriedade do usuário pelo índice', () {
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'johndoe@example.com',
      );

      final property = Property(
        id: '1',
        name: 'Farm A',
        location: 'Location A',
        aviaryCount: 2,
      );

      user.addProperty(property);
      expect(user.properties.length, 1);

      user.removeProperty(0);
      expect(user.properties, isEmpty);
    });

    test('Deve lançar exceção ao tentar remover propriedade com índice inválido', () {
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'johndoe@example.com',
      );

      expect(
        () => user.removeProperty(0),
        throwsA(isA<Exception>()),
      );
    });

    test('Deve converter para Map corretamente', () {
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'johndoe@example.com',
      );

      final userMap = user.toMap();
      expect(userMap['id'], '1');
      expect(userMap['name'], 'John Doe');
      expect(userMap['email'], 'johndoe@example.com');
      expect(userMap['properties'], isEmpty);
    });

    test('Deve criar User a partir de Map', () {
      final userMap = {
        'id': '1',
        'name': 'John Doe',
        'email': 'johndoe@example.com',
        'properties': [],
      };

      final user = User.fromMap(userMap, userMap['id'] as String);
      expect(user.id, '1');
      expect(user.name, 'John Doe');
      expect(user.email, 'johndoe@example.com');
      expect(user.properties, isEmpty);
    });
  });
}
