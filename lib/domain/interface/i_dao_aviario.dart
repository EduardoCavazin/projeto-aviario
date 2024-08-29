import 'package:projeto_avirario/domain/dto/dto_aviario.dart';

abstract class IDAOAviario {
  DTOAviario salvar(DTOAviario dto);
  DTOAviario? buscarPorId(dynamic id);
  List<DTOAviario> buscarTodos();
  void remover(dynamic id);
}
