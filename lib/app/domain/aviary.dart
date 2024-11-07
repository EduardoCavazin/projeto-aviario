import 'package:cloud_firestore/cloud_firestore.dart';

class Aviary {
  String id;
  String name;
  int capacity;

  Aviary({
    required this.id,
    required this.name,
    required this.capacity,
  }){
    _validate();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'capacity': capacity,
    };
  }

  factory Aviary.fromMap(Map<String, dynamic> map, String documentId) {
    return Aviary(
      id: documentId,
      name: map['name'],
      capacity: map['capacity'],
    );
  }

  Future<void> save() async {
    final collection = FirebaseFirestore.instance.collection('aviaries');

    if (id.isEmpty) {
      DocumentReference docRef = await collection.add(toMap());
      id = docRef.id; 
    } else {
      await collection.doc(id).set(toMap(), SetOptions(merge: true));
    }
  }

  Future<void> delete() async {
    await FirebaseFirestore.instance.collection('aviaries').doc(id).delete();
  }

  static Future<List<Aviary>> getAll() async {
    final snapshot = await FirebaseFirestore.instance.collection('aviaries').get();
    return snapshot.docs.map((doc) => Aviary.fromMap(doc.data(), doc.id)).toList();
  }

  static Future<Aviary?> getById(String id) async {
    final doc = await FirebaseFirestore.instance.collection('aviaries').doc(id).get();
    if (doc.exists) {
      return Aviary.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  void _validate() {
    _validateName();
    _validateCapacity();
  }

  void _validateName() {
    if (name.isEmpty) {
      throw Exception('Nome não pode ser vazio');
    }
  }

  void _validateCapacity() {
    if (capacity <= 20000 && capacity >= 50000) {
      throw Exception('Capacidade deve ser entre 20.000 e 50.000 aves');
    }
  }
}
