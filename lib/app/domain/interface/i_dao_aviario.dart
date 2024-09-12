import 'package:projeto_avirario/app/domain/dto/dto_aviario.dart';

abstract class IDAOAviario {
  DTOAviario salvar(DTOAviario dto);
  void deletar(dynamic id);
  DTOAviario? buscarPorId(dynamic id);
  List<DTOAviario> buscarTodos();
}
