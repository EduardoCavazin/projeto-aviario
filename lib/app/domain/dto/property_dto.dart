class PropertyDTO {
  String id;
  String name;
  String location;
  int aviaryCount;
  String userId;

  PropertyDTO({
    required this.id,
    required this.name,
    required this.location,
    required this.aviaryCount,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'userId': userId,
      'aviaryCount': aviaryCount,
    };
  }

  factory PropertyDTO.fromMap(Map<String, dynamic> map, String documentId) {
    return PropertyDTO(
      id: documentId,
      name: map['name'],
      location: map['location'],
      userId: map['userId'],
      aviaryCount: map['aviaryCount'] ?? 0,
    );
  }
}
