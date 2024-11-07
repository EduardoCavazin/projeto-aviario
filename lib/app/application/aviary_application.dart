import 'package:projeto_ddm/app/domain/dto/aviary_dto.dart';
import 'package:projeto_ddm/app/database/aviary_dao.dart';

class AviaryApplication {
  final AviaryDAO _aviaryDAO = AviaryDAO();

  Future<void> saveAviary(AviaryDTO aviary) async {
    try {
      await _aviaryDAO.save(aviary);
    } catch (e) {
      print("Erro ao salvar o aviário: $e");
      rethrow;
    }
  }

  Future<void> deleteAviary(String id) async {
    try {
      await _aviaryDAO.delete(id);
    } catch (e) {
      print("Erro ao deletar o aviário: $e");
      rethrow;
    }
  }

  Future<AviaryDTO?> getAviaryById(String id) async {
    try {
      return await _aviaryDAO.findById(id);
    } catch (e) {
      print("Erro ao buscar o aviário: $e");
      rethrow;
    }
  }

  Future<List<AviaryDTO>> getAllAviaries() async {
    try {
      return await _aviaryDAO.findAll();
    } catch (e) {
      print("Erro ao buscar todos os aviários: $e");
      rethrow;
    }
  }

  Future<AviaryDTO> createAviary(String name, int capacity) async {
    final aviary = AviaryDTO(
      id: '',
      name: name,
      capacity: capacity,
    );
    await saveAviary(aviary);
    return aviary;
  }

  Future<void> updateAviary(String id, String newName, int newCapacity) async {
    final aviary = await getAviaryById(id);
    if (aviary != null) {
      aviary.name = newName;
      aviary.capacity = newCapacity;
      await saveAviary(aviary);
    } else {
      print("Aviário não encontrado");
    }
  }
}
