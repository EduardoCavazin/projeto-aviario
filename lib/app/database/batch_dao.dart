import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_ddm/app/domain/dto/batch_dto.dart';
import 'package:projeto_ddm/app/domain/interface/batch_dao_interface.dart';

class BatchDAO implements IBatchDAO {
  final collection = FirebaseFirestore.instance.collection('batches');

  @override
  Future<void> save(BatchDTO batch) async {
    if (batch.id.isEmpty) {
      DocumentReference doc = await collection.add(batch.toMap());
      batch.id = doc.id;
    } else {
      await collection.doc(batch.id).set(batch.toMap(), SetOptions(merge: true));
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
    final snapshot = await collection.where('aviaryId', isEqualTo: aviaryId).get();
    return snapshot.docs
        .map((doc) => BatchDTO.fromMap(doc.data(), doc.id))
        .toList();
  }
}
