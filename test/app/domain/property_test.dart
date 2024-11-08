import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_ddm/app/domain/property.dart';

void main() {
  group('Property', () {
    test('Deve criar uma propriedade com dados válidos', () {
      final property = Property(
        id: '1',
        name: 'Farm A',
        location: 'Location A',
        aviaryCount: 2,
      );
      expect(property.id, '1');
      expect(property.name, 'Farm A');
      expect(property.location, 'Location A');
      expect(property.aviaryCount, 2);
    });

    test('Deve lançar exceção se o nome estiver vazio', () {
      expect(
        () => Property(id: '1', name: '', location: 'Location A', aviaryCount: 2),
        throwsA(isA<Exception>()),
      );
    });

    test('Deve lançar exceção se a localização estiver vazia', () {
      expect(
        () => Property(id: '1', name: 'Farm A', location: '', aviaryCount: 2),
        throwsA(isA<Exception>()),
      );
    });

    test('Deve converter a propriedade para Map corretamente', () {
      final property = Property(
        id: '1',
        name: 'Farm A',
        location: 'Location A',
        aviaryCount: 2,
      );

      final propertyMap = property.toMap();
      expect(propertyMap['id'], '1');
      expect(propertyMap['name'], 'Farm A');
      expect(propertyMap['location'], 'Location A');
      expect(propertyMap['aviaryCount'], 2);
    });

    test('Deve criar Property a partir de Map', () {
      final propertyMap = {
        'id': '1',
        'name': 'Farm A',
        'location': 'Location A',
        'aviaryCount': 2,
      };

      final property = Property.fromMap(propertyMap, propertyMap['id'] as String);
      expect(property.id, '1');
      expect(property.name, 'Farm A');
      expect(property.location, 'Location A');
      expect(property.aviaryCount, 2);
    });
  });
}
