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

  Future<BatchDTO> createBatch(String aviaryId, DateTime entryDate, int birdCount, double averageWeight, double initialFeedQuantity) async {
    final batch = BatchDTO(
      id: '', 
      aviaryId: aviaryId,
      entryDate: entryDate,
      birdCount: birdCount,
      averageWeight: averageWeight,
      initialFeedQuantity: initialFeedQuantity,
    );
    await saveBatch(batch);
    return batch;
  }

  Future<void> updateBatch(String id, int newBirdCount, double newAverageWeight, double newInitialFeedQuantity) async {
    final batch = await getBatchById(id);
    if (batch != null) {
      batch.birdCount = newBirdCount;
      batch.averageWeight = newAverageWeight;
      batch.initialFeedQuantity = newInitialFeedQuantity;
      await saveBatch(batch);
    } else {
      print("Lote não encontrado");
    }
  }
}
