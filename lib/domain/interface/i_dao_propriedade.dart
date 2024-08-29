import 'package:projeto_avirario/domain/dto/dto_propriedade.dart';

abstract class IDAOPropriedade {
  DTOPropriedade salvar(DTOPropriedade dto);
  void deletar(dynamic id);
  DTOPropriedade? buscarPorId(dynamic id);
  List<DTOPropriedade> buscarTodos();
}



