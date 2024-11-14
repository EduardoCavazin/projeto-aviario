class AviaryDTO {
  String id;
  String name;
  int capacity;
  String propertyId;


  AviaryDTO({
    required this.id,
    required this.name,
    required this.capacity,
    required this.propertyId
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'capacity': capacity,
      'propertyId': propertyId
    };
  }

  factory AviaryDTO.fromMap(Map<String, dynamic> map, String documentId) {
    return AviaryDTO(
      id: documentId,
      name: map['name'],
      capacity: map['capacity'],
      propertyId: map['propertyId']
    );
  }
}
