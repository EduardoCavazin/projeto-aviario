import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_ddm/app/domain/batch.dart';
import 'package:projeto_ddm/app/domain/aviary.dart';

void main() {
  group('Batch', () {
    final aviary = Aviary(id: '1', name: 'Aviary A', capacity: 30000);

    test('Deve criar um lote com dados válidos', () {
      final batch = Batch(
        id: '1',
        aviaryId: aviary.id,
        entryDate: DateTime.now(),
        birdCount: 15000,
        averageWeight: 1.5,
        initialFeedQuantity: 100.0,
        aviary: aviary,
      );
      expect(batch.id, '1');
      expect(batch.birdCount, 15000);
      expect(batch.averageWeight, 1.5);
      expect(batch.initialFeedQuantity, 100.0);
    });

    test('Deve lançar exceção se a quantidade de aves exceder a capacidade do aviário', () {
      expect(
        () => Batch(
          id: '1',
          aviaryId: aviary.id,
          entryDate: DateTime.now(),
          birdCount: 35000, 
          averageWeight: 1.5,
          initialFeedQuantity: 100.0,
          aviary: aviary,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Deve lançar exceção se a quantidade de aves for zero ou negativa', () {
      expect(
        () => Batch(
          id: '1',
          aviaryId: aviary.id,
          entryDate: DateTime.now(),
          birdCount: 0,
          averageWeight: 1.5,
          initialFeedQuantity: 100.0,
          aviary: aviary,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Deve lançar exceção se o peso médio for zero ou negativo', () {
      expect(
        () => Batch(
          id: '1',
          aviaryId: aviary.id,
          entryDate: DateTime.now(),
          birdCount: 15000,
          averageWeight: 0,
          initialFeedQuantity: 100.0,
          aviary: aviary,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Deve lançar exceção se a quantidade inicial de ração for zero ou negativa', () {
      expect(
        () => Batch(
          id: '1',
          aviaryId: aviary.id,
          entryDate: DateTime.now(),
          birdCount: 15000,
          averageWeight: 1.5,
          initialFeedQuantity: 0,
          aviary: aviary,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Deve converter o lote para Map corretamente', () {
      final batch = Batch(
        id: '1',
        aviaryId: aviary.id,
        entryDate: DateTime.now(),
        birdCount: 15000,
        averageWeight: 1.5,
        initialFeedQuantity: 100.0,
        aviary: aviary,
      );

      final batchMap = batch.toMap();
      expect(batchMap['id'], '1');
      expect(batchMap['aviaryId'], aviary.id);
      expect(batchMap['birdCount'], 15000);
      expect(batchMap['averageWeight'], 1.5);
      expect(batchMap['initialFeedQuantity'], 100.0);
    });

    test('Deve criar Batch a partir de Map', () {
      final batchMap = {
        'id': '1',
        'aviaryId': aviary.id,
        'entryDate': DateTime.now().toIso8601String(),
        'birdCount': 15000,
        'averageWeight': 1.5,
        'initialFeedQuantity': 100.0,
      };

      final batch = Batch.fromMap(batchMap, batchMap['id'] as String);
      expect(batch.id, '1');
      expect(batch.aviaryId, aviary.id);
      expect(batch.birdCount, 15000);
      expect(batch.averageWeight, 1.5);
      expect(batch.initialFeedQuantity, 100.0);
    });
  });
}
