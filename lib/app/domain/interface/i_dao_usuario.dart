import 'package:projeto_avirario/app/domain/dto/dto_usuario.dart';

abstract class IDAOUsuario {
  Future<DTOUsuario> salvar(DTOUsuario dto);
  Future<DTOUsuario?> buscarPorId(dynamic id);
  Future<List<DTOUsuario>> buscarUsuarios();
  Future<void> deletar(dynamic id);
  Future<DTOUsuario?> buscarPorEmail(String email);
}
