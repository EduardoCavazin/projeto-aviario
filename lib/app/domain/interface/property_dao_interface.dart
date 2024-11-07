import 'package:projeto_ddm/app/domain/dto/property_dto.dart';

abstract class IPropertyDAO {
  Future<void> save(PropertyDTO property);
  Future<void> delete(String id);
  Future<PropertyDTO?> findById(String id);
  Future<List<PropertyDTO>> findAll();
}
