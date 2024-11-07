import 'package:cloud_firestore/cloud_firestore.dart';
import 'aviary.dart';

class Property {
  String id;
  String name;
  String location;
  int aviaryCount;
  List<Aviary> aviaries;

  Property({
    required this.id,
    required this.name,
    required this.location,
    this.aviaryCount = 0,
    this.aviaries = const [],
  }){
    _validate();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'aviaryCount': aviaries.length, 
      'aviaries': aviaries.map((aviary) => aviary.toMap()).toList(),
    };
  }

  factory Property.fromMap(Map<String, dynamic> map, String documentId) {
    return Property(
      id: documentId,
      name: map['name'],
      location: map['location'],
      aviaryCount: map['aviaryCount'] ?? 0,
      aviaries: (map['aviaries'] as List)
          .map((aviaryMap) => Aviary.fromMap(aviaryMap, aviaryMap['id']))
          .toList(),
    );
  }

  Future<void> save() async {
    final collection = FirebaseFirestore.instance.collection('properties');

    if (id.isEmpty) {
      DocumentReference docRef = await collection.add(toMap());
      id = docRef.id; 
    } else {
      await collection.doc(id).set(toMap(), SetOptions(merge: true));
    }
  }

  Future<void> delete() async {
    await FirebaseFirestore.instance.collection('properties').doc(id).delete();
  }

  static Future<List<Property>> getAll() async {
    final snapshot = await FirebaseFirestore.instance.collection('properties').get();
    return snapshot.docs.map((doc) => Property.fromMap(doc.data(), doc.id)).toList();
  }

  static Future<Property?> getById(String id) async {
    final doc = await FirebaseFirestore.instance.collection('properties').doc(id).get();
    if (doc.exists) {
      return Property.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  void addAviary(Aviary aviary) {
    aviaries.add(aviary);
    aviaryCount = aviaries.length;
  }

  void removeAviary(int index) {
    if (index >= 0 && index < aviaries.length) {
      aviaries.removeAt(index);
      aviaryCount = aviaries.length;
    } else {
      throw Exception('Index de aviário inválido, aviário não encontrado.');
    }
  }

  void _validate() {
    _validateName();
    _validateLocation();
  }

  void _validateName() {
    if (name.trim().isEmpty) {
      throw Exception('Nome da prorpiedade não pode ser vazio');
    }
  }

  void _validateLocation() {
    if (location.trim().isEmpty) {
      throw Exception('Localização da propriedade não pode ser vazia');
    }
  }
}
