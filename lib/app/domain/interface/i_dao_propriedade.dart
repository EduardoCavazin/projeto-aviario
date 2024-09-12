import 'package:projeto_avirario/app/domain/dto/dto_propriedade.dart';

abstract class IDAOPropriedade {
  DTOPropriedade salvar(DTOPropriedade dto);
  void deletarPropriedade(dynamic id);
  DTOPropriedade? buscarPorId(dynamic id);
  List<DTOPropriedade> buscarPropriedade();
}



