import 'package:projeto_avirario/domain/dto/dto_aviario.dart';

abstract class IDAOAviario {
  DTOAviario salvar(DTOAviario dto);
  void deletar(dynamic id);
  DTOAviario? buscarPorId(dynamic id);
  List<DTOAviario> buscarTodos();
}
