import 'package:projeto_avirario/app/domain/dto/dto_propriedade.dart';

abstract class IDAOPropriedade {
  Future<DTOPropriedade> salvar(DTOPropriedade dto);
  Future<void> deletarPropriedade(dynamic id);
  Future<DTOPropriedade?> buscarPorId(dynamic id);
  Future<List<DTOPropriedade>> buscarPropriedade();
}
