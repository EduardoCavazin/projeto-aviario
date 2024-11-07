import 'package:projeto_ddm/app/domain/dto/user_dto.dart';

abstract class IUserDAO {
  Future<void> save(UserDTO user);
  Future<void> delete(String id);
  Future<UserDTO?> findById(String id);
  Future<List<UserDTO>> findAll();
}
