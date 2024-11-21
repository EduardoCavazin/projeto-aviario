import 'package:projeto_ddm/app/domain/dto/batch_dto.dart';
import 'package:projeto_ddm/app/database/batch_dao.dart';

class BatchApplication {
  final BatchDAO _batchDAO = BatchDAO();

  Future<void> saveBatch(BatchDTO batch) async {
    try {
      await _batchDAO.save(batch);
    } catch (e) {
      print("Erro ao salvar o lote: $e");
      rethrow;
    }
  }

  Future<void> deleteBatch(String id) async {
    try {
      await _batchDAO.delete(id);
    } catch (e) {
      print("Erro ao deletar o lote: $e");
      rethrow;
    }
  }

  Future<BatchDTO?> getBatchById(String id) async {
    try {
      return await _batchDAO.findById(id);
    } catch (e) {
      print("Erro ao buscar o lote: $e");
      rethrow;
    }
  }

  Future<List<BatchDTO>> getAllBatchesByAviary(String aviaryId) async {
    try {
      return await _batchDAO.findAllByAviary(aviaryId);
    } catch (e) {
      print("Erro ao buscar lotes do aviário: $e");
      rethrow;
    }
  }

  Future<BatchDTO> createBatch(String aviaryId, DateTime entryDate, int birdCount) async {
    final batch = BatchDTO(
      id: '',
      aviaryId: aviaryId,
      entryDate: entryDate,
      birdCount: birdCount,
      feedRecords: [],
      mortalityRecords: [],
      weightRecords: [],
    );
    await saveBatch(batch);
    return batch;
  }

  Future<void> updateBatch(String id, int newBirdCount) async {
    final batch = await getBatchById(id);
    if (batch != null) {
      batch.birdCount = newBirdCount;
      await saveBatch(batch);
    } else {
      print("Lote não encontrado");
    }
  }

  Future<void> addFeedRecord(String batchId, Map<String, dynamic> feedRecord) async {
    try {
      await _batchDAO.addFeedRecord(batchId, feedRecord);
    } catch (e) {
      print("Erro ao adicionar registro de ração: $e");
      rethrow;
    }
  }

  Future<void> addMortalityRecord(String batchId, Map<String, dynamic> mortalityRecord) async {
    try {
      await _batchDAO.addMortalityRecord(batchId, mortalityRecord);
    } catch (e) {
      print("Erro ao adicionar registro de mortalidade: $e");
      rethrow;
    }
  }

  Future<void> addWeightRecord(String batchId, Map<String, dynamic> weightRecord) async {
    try {
      await _batchDAO.addWeightRecord(batchId, weightRecord);
    } catch (e) {
      print("Erro ao adicionar registro de peso: $e");
      rethrow;
    }
  }
}
