import 'package:projeto_ddm/app/domain/dto/property_dto.dart';
import 'package:projeto_ddm/app/database/property_dao.dart';

class PropertyApplication {
  final PropertyDAO _propertyDAO = PropertyDAO();

  Future<void> saveProperty(PropertyDTO property) async {
    try {
      await _propertyDAO.save(property);
    } catch (e) {
      print("Erro ao salvar a propriedade: $e");
      rethrow;
    }
  }

  Future<void> deleteProperty(String id) async {
    try {
      await _propertyDAO.delete(id);
    } catch (e) {
      print("Erro ao deletar a propriedade: $e");
      rethrow;
    }
  }

  Future<PropertyDTO?> getPropertyById(String id) async {
    try {
      return await _propertyDAO.findById(id);
    } catch (e) {
      print("Erro ao buscar a propriedade: $e");
      rethrow;
    }
  }

  Future<List<PropertyDTO>> getAllPropertiesByUser(String userId) async {
    try {
      return await _propertyDAO.findAllByUser(userId);
    } catch (e) {
      print("Erro ao buscar propriedades para o usuário $userId: $e");
      rethrow;
    }
  }

  Future<PropertyDTO> createProperty(String name, String location, int aviaryCount, String userId) async {
    final property = PropertyDTO(
      id: '',
      name: name,
      location: location,
      aviaryCount: aviaryCount,
      userId: userId,
    );
    await saveProperty(property);
    return property;
  }

  Future<void> updateProperty(String id, String newName, String newLocation, int newAviaryCount) async {
    final property = await getPropertyById(id);
    if (property != null) {
      property.name = newName;
      property.location = newLocation;
      property.aviaryCount = newAviaryCount;
      await saveProperty(property);
    } else {
      print("Propriedade não encontrada");
    }
  }
}
