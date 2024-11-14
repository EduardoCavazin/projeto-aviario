import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_ddm/app/domain/dto/property_dto.dart';
import 'package:projeto_ddm/app/domain/interface/property_dao_interface.dart';

class PropertyDAO implements IPropertyDAO {
  final collection = FirebaseFirestore.instance.collection('properties');

  @override
  Future<void> save(PropertyDTO property) async {
    final data = property.toMap();
    data['userId'] = property.userId;

    if (property.id.isEmpty) {
      DocumentReference doc = await collection.add(data);
      property.id = doc.id;
      await collection.doc(property.id).update({'id': property.id}); 
    } else {
      await collection.doc(property.id).set(data, SetOptions(merge: true));
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

  Future<List<PropertyDTO>> findAllByUser(String userId) async {
    final snapshot = await collection.where('userId', isEqualTo: userId).get();
    return snapshot.docs
        .map((doc) => PropertyDTO.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<List<PropertyDTO>> findAll() async {
    final snapshot = await collection.get();
    return snapshot.docs
        .map((doc) => PropertyDTO.fromMap(doc.data(), doc.id))
        .toList();
  }
}
