class PropertyDTO {
  final String id;
  final String name;
  final String location;
  final int aviaryCount;

  PropertyDTO({
    required this.id,
    required this.name,
    required this.location,
    required this.aviaryCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'aviaryCount': aviaryCount,
    };
  }

  factory PropertyDTO.fromMap(Map<String, dynamic> map, String documentId) {
    return PropertyDTO(
      id: documentId,
      name: map['name'],
      location: map['location'],
      aviaryCount: map['aviaryCount'] ?? 0,
    );
  }
}