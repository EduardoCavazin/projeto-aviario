class UserDTO{
  
  final String id;
  final String name;
  final String email;

  UserDTO({
    required this.id,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  factory UserDTO.fromMap(Map<String, dynamic> map) {
    return UserDTO(
      id: map['id'],
      name: map['name'],
      email: map['email'],
    );
  } 

}