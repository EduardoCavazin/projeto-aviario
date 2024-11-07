import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_ddm/app/domain/dto/property_dto.dart';
import 'package:projeto_ddm/app/domain/interface/property_dao_interface.dart';

class PropertyDAO implements IPropertyDAO {
  final collection = FirebaseFirestore.instance.collection('properties');

  @override
  Future<void> save(PropertyDTO property) async {
    if (property.id.isEmpty) {
      DocumentReference doc = await collection.add(property.toMap());
      property.id = doc.id;
    } else {
      await collection.doc(property.id).set(property.toMap(), SetOptions(merge: true));
    }
  }

  @override
  Future<void> delete(String id) async {
    await collection.doc(id).delete();
  }

  @override
  Future<PropertyDTO?> findById(String id) async {
    final doc = await collection.doc(id).get();
    if (doc.exists) {
      return PropertyDTO.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  @override
  Future<List<PropertyDTO>> findAll() async {
    final snapshot = await collection.get();
    return snapshot.docs
        .map((doc) => PropertyDTO.fromMap(doc.data(), doc.id))
        .toList();
  }
}
