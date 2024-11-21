import 'package:projeto_ddm/app/domain/dto/batch_dto.dart';

abstract class IBatchDAO {
  Future<void> save(BatchDTO batch);
  Future<void> delete(String id);
  Future<BatchDTO?> findById(String id);
  Future<List<BatchDTO>> findAllByAviary(String aviaryId);
  Future<void> addFeedRecord(String batchId, Map<String, dynamic> feedRecord);
  Future<void> addMortalityRecord(String batchId, Map<String, dynamic> mortalityRecord);
  Future<void> addWeightRecord(String batchId, Map<String, dynamic> weightRecord);
}