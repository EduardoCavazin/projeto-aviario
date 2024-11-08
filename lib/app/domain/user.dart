import 'package:cloud_firestore/cloud_firestore.dart';
import 'property.dart';

class User {
  String id;
  String name;
  String email;
  List<Property> properties;

  User({
    required this.id,
    required this.name,
    required this.email,
    List<Property>? properties,
  }) : properties = properties ?? [] {
    _validate();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'properties': properties.map((property) => property.toMap()).toList(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User(
      id: id,
      name: map['name'],
      email: map['email'],
      properties: (map['properties'] as List)
          .map(
              (propertyMap) => Property.fromMap(propertyMap, propertyMap['id']))
          .toList(),
    );
  }

  Future<void> save() async {
    final collection = FirebaseFirestore.instance.collection('users');

    if (id.isEmpty) {
      DocumentReference doc = await collection.add(toMap());
      id = doc.id;
    } else {
      await collection.doc(id).set(toMap(), SetOptions(merge: true));
    }
  }

  Future<void> delete() async {
    await FirebaseFirestore.instance.collection('users').doc(id).delete();
  }

  static Future<List<User>> findAll() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    return snapshot.docs
        .map((doc) => User.fromMap(doc.data(), doc.id))
        .toList();
  }

  static Future<User?> getById(String id) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    if (doc.exists) {
      return User.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  void addProperty(Property property) {
    properties.add(property);
  }

  void removeProperty(int index) {
    if (index >= 0 && index < properties.length) {
      properties.removeAt(index);
    } else {
      throw Exception('Invalid property index. Property not found.');
    }
  }

  static Future<User?> findById(String id) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    if (doc.exists) {
      return User.fromMap(doc.data()!, doc.id);
    } else {
      return null;
    }
  }

  void _validate() {
    _validateName();
    _validateEmail();
  }

  void _validateName() {
    if (name.isEmpty) {
      throw Exception('O nome é obrigatório');
    }
  }

  void _validateEmail() {
    if (email.isEmpty) {
      throw Exception('O e-mail é obrigatório');
    } else if (!email.contains('@')) {
      throw Exception('E-mail inválido');
    }
  }
}
