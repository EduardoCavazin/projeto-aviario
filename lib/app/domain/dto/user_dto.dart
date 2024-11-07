import 'package:projeto_ddm/app/domain/property.dart';

class UserDTO{
  
  String id;
  String name;
  String email;
  List<Property> properties;

  UserDTO({
    required this.id,
    required this.name,
    required this.email,
    this.properties = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'properties': properties.map((property) => property.toMap()).toList(),
    };
  }

  factory UserDTO.fromMap(Map<String, dynamic> map, String id) {
    return UserDTO(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      properties: (map['properties'] as List)
          .map((propertyMap) => Property.fromMap(propertyMap, propertyMap['id']))
          .toList(),
    );
  } 

}