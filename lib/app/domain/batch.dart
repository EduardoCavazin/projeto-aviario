import 'package:cloud_firestore/cloud_firestore.dart';
import 'aviary.dart';

class Batch {
  String id;
  String aviaryId;
  DateTime entryDate;
  int birdCount;
  double averageWeight;
  double initialFeedQuantity;

  Batch({
    required this.id,
    required this.aviaryId,
    required this.entryDate,
    required this.birdCount,
    required this.averageWeight,
    required this.initialFeedQuantity,
    required Aviary aviary,
  }){
    _validate(aviary);
  }

  Batch._withoutValidation({
  required this.id,
  required this.aviaryId,
  required this.entryDate,
  required this.birdCount,
  required this.averageWeight,
  required this.initialFeedQuantity,
});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'aviaryId': aviaryId,
      'entryDate': entryDate.toIso8601String(),
      'birdCount': birdCount,
      'averageWeight': averageWeight,
      'initialFeedQuantity': initialFeedQuantity,
    };
  }

  factory Batch.fromMap(Map<String, dynamic> map, String documentId) {
    return Batch._withoutValidation(
      id: documentId,
      aviaryId: map['aviaryId'],
      entryDate: DateTime.parse(map['entryDate']),
      birdCount: map['birdCount'],
      averageWeight: map['averageWeight'],
      initialFeedQuantity: map['initialFeedQuantity'],
      
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
    _validateAverageWeight();
    _validateFeedQuantity();
  }

  void _validateBirdCount(Aviary aviary) {
    if (birdCount <= 0) {
      throw Exception('Bird count must be greater than zero');
    }
    if (birdCount > aviary.capacity) {
      throw Exception('Bird count exceeds aviary capacity of ${aviary.capacity}');
    }
  }

  void _validateAverageWeight() {
    if (averageWeight <= 0) {
      throw Exception('Average weight must be greater than zero');
    }
  }

  void _validateFeedQuantity() {
    if (initialFeedQuantity <= 0) {
      throw Exception('Initial feed quantity must be greater than zero');
    }
  }
}
