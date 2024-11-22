class BatchDTO {
  String id;
  String name;
  String aviaryId;
  DateTime entryDate;
  int birdCount;
  List<Map<String, dynamic>> feedRecords;
  List<Map<String, dynamic>> mortalityRecords;
  List<Map<String, dynamic>> weightRecords;

  BatchDTO({
    required this.id,
    required this.name,
    required this.aviaryId,
    required this.entryDate,
    required this.birdCount,
    this.feedRecords = const [],
    this.mortalityRecords = const [],
    this.weightRecords = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'aviaryId': aviaryId,
      'entryDate': entryDate.toIso8601String(),
      'birdCount': birdCount,
      'feedRecords': feedRecords,
      'mortalityRecords': mortalityRecords,
      'weightRecords': weightRecords,
    };
  }

  factory BatchDTO.fromMap(Map<String, dynamic> map, String documentId) {
    return BatchDTO(
      id: documentId,
      name: map['name'],
      aviaryId: map['aviaryId'],
      entryDate: DateTime.parse(map['entryDate']),
      birdCount: map['birdCount'],
      feedRecords: (map['feedRecords'] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
      mortalityRecords: (map['mortalityRecords'] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
      weightRecords: (map['weightRecords'] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
    );
  }
}
