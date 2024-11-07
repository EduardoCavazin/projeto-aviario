import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_ddm/app/domain/dto/user_dto.dart';
import 'package:projeto_ddm/app/domain/interface/user_dao_interface.dart';

class UserDAO implements IUserDAO {
  final collection = FirebaseFirestore.instance.collection('users');

  @override
  Future<void> save(UserDTO user) async {
    if (user.id.isEmpty) {
      DocumentReference doc = await collection.add(user.toMap());
      user.id = doc.id; 
    } else {
      await collection.doc(user.id).set(user.toMap(), SetOptions(merge: true));
    }
  }

  @override
  Future<void> delete(String id) async {
    await collection.doc(id).delete();
  }

  @override
  Future<UserDTO?> findById(String id) async {
    final doc = await collection.doc(id).get();
    if (doc.exists) {
      return UserDTO.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  @override
  Future<List<UserDTO>> findAll() async {
    final snapshot = await collection.get();
    return snapshot.docs
        .map((doc) => UserDTO.fromMap(doc.data(), doc.id))
        .toList();
  }
}
