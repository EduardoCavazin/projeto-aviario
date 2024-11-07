class BatchDTO {
  final String id;
  final String aviaryId;
  final DateTime entryDate;
  final int birdCount;
  final double averageWeight;
  final double initialFeedQuantity;

  BatchDTO({
    required this.id,
    required this.aviaryId,
    required this.entryDate,
    required this.birdCount,
    required this.averageWeight,
    required this.initialFeedQuantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'aviaryId': aviaryId,
      'entryDate': entryDate.toIso8601String(),
      'birdCount': birdCount,
      'averageWeight': averageWeight,
      'initialFeedQuantity': initialFeedQuantity,
    };
  }

  factory BatchDTO.fromMap(Map<String, dynamic> map, String documentId) {
    return BatchDTO(
      id: documentId,
      aviaryId: map['aviaryId'],
      entryDate: DateTime.parse(map['entryDate']),
      birdCount: map['birdCount'],
      averageWeight: map['averageWeight'],
      initialFeedQuantity: map['initialFeedQuantity'],
    );
  }
}
