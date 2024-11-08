import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_ddm/app/domain/aviary.dart';

void main() {
  group('Aviary', () {
    test('Deve criar um aviário com dados válidos', () {
      final aviary = Aviary(
        id: '1',
        name: 'Aviary A',
        capacity: 1000,
      );
      expect(aviary.id, '1');
      expect(aviary.name, 'Aviary A');
      expect(aviary.capacity, 1000);
    });

    test('Deve lançar exceção se o nome do aviário estiver vazio', () {
      expect(
        () => Aviary(id: '1', name: '', capacity: 1000),
        throwsA(isA<Exception>()),
      );
    });

    test('Deve lançar exceção se a capacidade for zero ou negativa', () {
      expect(
        () => Aviary(id: '1', name: 'Aviary A', capacity: 0),
        throwsA(isA<Exception>()),
      );
      expect(
        () => Aviary(id: '1', name: 'Aviary A', capacity: -10),
        throwsA(isA<Exception>()),
      );
    });

    test('Deve converter o aviário para Map corretamente', () {
      final aviary = Aviary(
        id: '1',
        name: 'Aviary A',
        capacity: 1000,
      );

      final aviaryMap = aviary.toMap();
      expect(aviaryMap['id'], '1');
      expect(aviaryMap['name'], 'Aviary A');
      expect(aviaryMap['capacity'], 1000);
    });

    test('Deve criar Aviary a partir de Map', () {
      final aviaryMap = {
        'id': '1',
        'name': 'Aviary A',
        'capacity': 1000,
      };

      final aviary = Aviary.fromMap(aviaryMap, aviaryMap['id'] as String);
      expect(aviary.id, '1');
      expect(aviary.name, 'Aviary A');
      expect(aviary.capacity, 1000);
    });
  });
}
