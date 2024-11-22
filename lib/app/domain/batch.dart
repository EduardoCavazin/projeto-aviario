import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_ddm/app/domain/aviary.dart';

class Batch {
  String id;
  String name;
  String aviaryId;
  DateTime entryDate;
  int birdCount;
  List<Map<String, dynamic>> feedRecords;
  List<Map<String, dynamic>> mortalityRecords;
  List<Map<String, dynamic>> weightRecords;

  Batch({
    required this.id,
    required this.name,
    required this.aviaryId,
    required this.entryDate,
    required this.birdCount,
    this.feedRecords = const [],
    this.mortalityRecords = const [],
    this.weightRecords = const [],
    required Aviary aviary,
  }) {
    _validate(aviary); 
  }

  Batch._withoutValidation({
    required this.id,
    required this.name,
    required this.aviaryId,
    required this.entryDate,
    required this.birdCount,
    this.feedRecords = const [],
    this.mortalityRecords = const [],
    this.weightRecords = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'aviaryId': aviaryId,
      'entryDate': entryDate.toIso8601String(),
      'birdCount': birdCount,
      'feedRecords': feedRecords,
      'mortalityRecords': mortalityRecords,
      'weightRecords': weightRecords,
    };
  }

  factory Batch.fromMap(Map<String, dynamic> map, String documentId) {
    return Batch._withoutValidation(
      id: documentId,
      name: map['name'],
      aviaryId: map['aviaryId'],
      entryDate: DateTime.parse(map['entryDate']),
      birdCount: map['birdCount'],
      feedRecords: List<Map<String, dynamic>>.from(map['feedRecords'] ?? []),
      mortalityRecords: List<Map<String, dynamic>>.from(map['mortalityRecords'] ?? []),
      weightRecords: List<Map<String, dynamic>>.from(map['weightRecords'] ?? []),
    );
  }

  Future<void> save(Aviary aviary) async {
    _validate(aviary);

    final collection = FirebaseFirestore.instance.collection('batches');

    if (id.isEmpty) {
      DocumentReference docRef = await collection.add(toMap());
      id = docRef.id;
    } else {
      await collection.doc(id).set(toMap(), SetOptions(merge: true));
    }
  }

  Future<void> delete() async {
    await FirebaseFirestore.instance.collection('batches').doc(id).delete();
  }

  static Future<List<Batch>> getAllByAviary(String aviaryId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('batches')
        .where('aviaryId', isEqualTo: aviaryId)
        .get();

    return snapshot.docs.map((doc) => Batch.fromMap(doc.data(), doc.id)).toList();
  }

  static Future<Batch?> getById(String id) async {
    final doc = await FirebaseFirestore.instance.collection('batches').doc(id).get();
    if (doc.exists) {
      return Batch.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  void _validate(Aviary aviary) {
    _validateBirdCount(aviary);
  }

  void _validateBirdCount(Aviary aviary) {
    if (birdCount <= 0) {
      throw Exception('Bird count must be greater than zero');
    }
    if (birdCount > aviary.capacity) {
      throw Exception('Bird count exceeds aviary capacity of ${aviary.capacity}');
    }
  }

  void addFeedRecord(DateTime date, double quantity) {
    if (quantity == 0) {
      throw Exception('Feed quantity cannot be zero.');
    }

    feedRecords.add({
      'date': date.toIso8601String(),
      'quantity': quantity,
    });
  }

  void addMortalityRecord(DateTime date, int mortalityCount) {
    if (mortalityCount < 0) {
      throw Exception('Mortality count cannot be negative.');
    }

    final totalMortality = calculateTotalMortality();
    if (totalMortality + mortalityCount > birdCount) {
      throw Exception('Total mortality exceeds initial bird count.');
    }

    mortalityRecords.add({
      'date': date.toIso8601String(),
      'mortalityCount': mortalityCount,
    });
  }

  void addWeightRecord(int week, double averageWeight) {
    if (averageWeight <= 0) {
      throw Exception('Average weight must be greater than zero.');
    }

    weightRecords.add({
      'week': week,
      'averageWeight': averageWeight,
    });
  }

  int calculateTotalMortality() {
    return mortalityRecords.fold(0, (total, record) => total + (record['mortalityCount'] as int));
  }

  double calculateFeedBalance() {
    return feedRecords.fold(0.0, (total, record) => total + (record['quantity'] as double));
  }

  double getFinalAverageWeight() {
    if (weightRecords.isEmpty) {
      throw Exception('No weight records available.');
    }
    return weightRecords.last['averageWeight'] as double;
  }
}
