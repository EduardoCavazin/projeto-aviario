import 'package:projeto_avirario/domain/dto/dto_lote.dart';

abstract class IDAOLote {
  DTOLote salvar(DTOLote dto);
  DTOLote? buscarPorId(dynamic id);
  List<DTOLote> buscarTodos();
  void deletar(dynamic id);
}
