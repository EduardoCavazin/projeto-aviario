import 'package:projeto_ddm/app/domain/dto/aviary_dto.dart';

abstract class IAviaryDAO {
  Future<void> save(AviaryDTO aviary);
  Future<void> delete(String id);
  Future<AviaryDTO?> findById(String id);
  Future<List<AviaryDTO>> findAll();
}
