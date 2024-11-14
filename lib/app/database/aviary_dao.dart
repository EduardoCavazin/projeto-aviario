import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_ddm/app/domain/dto/aviary_dto.dart';

class AviaryDAO {
  final collection = FirebaseFirestore.instance.collection('aviaries');

  Future<void> save(AviaryDTO aviary) async {
    final data = aviary.toMap();
    data['propertyId'] = aviary.propertyId;

    if (aviary.id.isEmpty) {
      DocumentReference doc = await collection.add(data);
      aviary.id = doc.id;
      await collection.doc(aviary.id).update({'id': aviary.id});
    } else {
      await collection.doc(aviary.id).set(data, SetOptions(merge: true));
    }
  }

  Future<void> delete(String id) async {
    await collection.doc(id).delete();
  }

  Future<AviaryDTO?> findById(String id) async {
    final doc = await collection.doc(id).get();
    if (doc.exists) {
      return AviaryDTO.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<List<AviaryDTO>> findAll() async {
    final snapshot = await collection.get();
    return snapshot.docs.map((doc) => AviaryDTO.fromMap(doc.data(), doc.id)).toList();
  }

  Future<List<AviaryDTO>> findAllByProperty(String propertyId) async {
    final snapshot = await collection.where('propertyId', isEqualTo: propertyId).get();
    return snapshot.docs.map((doc) => AviaryDTO.fromMap(doc.data(), doc.id)).toList();
  }
}
