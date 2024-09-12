import 'package:projeto_avirario/app/domain/dto/dto_aviario.dart';

abstract class IDAOAviario {
  Future<DTOAviario> salvar(DTOAviario dto);
  Future<void> deletar(dynamic id);
  Future<DTOAviario?> buscarPorId(dynamic id);
  Future<List<DTOAviario>> buscarTodos();
}
