import 'package:projeto_avirario/domain/dto/dto_propriedade.dart';

abstract class IDAOPropriedade {
  DTOPropriedade salvar(DTOPropriedade dto);
  DTOPropriedade? buscarPorId(dynamic id);
  List<DTOPropriedade> buscarTodos();
  void remover(dynamic id);
}
