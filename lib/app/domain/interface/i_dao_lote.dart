import 'package:projeto_avirario/app/domain/dto/dto_lote.dart';

abstract class IDAOLote {
  Future<DTOLote> salvar(DTOLote dto);
  Future<DTOLote?> buscarPorId(dynamic id);
  Future<List<DTOLote>> buscarTodos();
  Future<void> deletar(dynamic id);
}
