import 'package:projeto_avirario/domain/dto/dto_usuario.dart';

abstract class IDAOUsuario {
  DTOUsuario salvar(DTOUsuario dto);
  DTOUsuario? buscarPorId(dynamic id);
  List<DTOUsuario> buscarTodos();
  void deletar(dynamic id);

}
