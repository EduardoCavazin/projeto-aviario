import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_ddm/app/domain/dto/batch_dto.dart';
import 'package:projeto_ddm/app/domain/interface/batch_dao_interface.dart';

class BatchDAO implements IBatchDAO {
  final collection = FirebaseFirestore.instance.collection('batches');

  @override
  Future<void> save(BatchDTO batch) async {
    final data = batch.toMap();
    data['aviaryId'] = batch.aviaryId;

    if (batch.id.isEmpty) {
      DocumentReference doc = await collection.add(data);
      batch.id = doc.id;
      await collection.doc(batch.id).update({'id': batch.id});
    } else {
      await collection.doc(batch.id).set(data, SetOptions(merge: true));
    }
  }

  @override
  Future<void> delete(String id) async {
    await collection.doc(id).delete();
  }

  @override
  Future<BatchDTO?> findById(String id) async {
    final doc = await collection.doc(id).get();
    if (doc.exists) {
      return BatchDTO.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  @override
  Future<List<BatchDTO>> findAllByAviary(String aviaryId) async {
    final snapshot =
        await collection.where('aviaryId', isEqualTo: aviaryId).get();
    return snapshot.docs
        .map((doc) => BatchDTO.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> addFeedRecord(
      String batchId, Map<String, dynamic> feedRecord) async {
    final docRef = collection.doc(batchId);
    await docRef.update({
      'feedRecords': FieldValue.arrayUnion([feedRecord]),
    });
  }

  @override
  Future<void> addMortalityRecord(
      String batchId, Map<String, dynamic> mortalityRecord) async {
    final docRef = collection.doc(batchId);
    await docRef.update({
      'mortalityRecords': FieldValue.arrayUnion([mortalityRecord]),
    });
  }

  @override
  Future<void> addWeightRecord(
      String batchId, Map<String, dynamic> weightRecord) async {
    final docRef = collection.doc(batchId);
    await docRef.update({
      'weightRecords': FieldValue.arrayUnion([weightRecord]),
    });
  }
}
