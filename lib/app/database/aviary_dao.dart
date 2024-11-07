import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_ddm/app/domain/dto/aviary_dto.dart';
import 'package:projeto_ddm/app/domain/interface/aviary_dao_interface.dart';

class AviaryDAO implements IAviaryDAO {
  final collection = FirebaseFirestore.instance.collection('aviaries');

  @override
  Future<void> save(AviaryDTO aviary) async {
    if (aviary.id.isEmpty) {
      DocumentReference doc = await collection.add(aviary.toMap());
      aviary.id = doc.id;
    } else {
      await collection.doc(aviary.id).set(aviary.toMap(), SetOptions(merge: true));
    }
  }

  @override
  Future<void> delete(String id) async {
    await collection.doc(id).delete();
  }

  @override
  Future<AviaryDTO?> findById(String id) async {
    final doc = await collection.doc(id).get();
    if (doc.exists) {
      return AviaryDTO.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  @override
  Future<List<AviaryDTO>> findAll() async {
    final snapshot = await collection.get();
    return snapshot.docs
        .map((doc) => AviaryDTO.fromMap(doc.data(), doc.id))
        .toList();
  }
}
