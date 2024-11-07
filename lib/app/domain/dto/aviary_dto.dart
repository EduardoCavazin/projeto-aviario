class AviaryDTO {
  final String id;
  final String name;
  final int capacity;

  AviaryDTO({
    required this.id,
    required this.name,
    required this.capacity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'capacity': capacity,
    };
  }

  factory AviaryDTO.fromMap(Map<String, dynamic> map, String documentId) {
    return AviaryDTO(
      id: documentId,
      name: map['name'],
      capacity: map['capacity'],
    );
  }
}
