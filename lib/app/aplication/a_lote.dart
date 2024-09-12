import 'package:projeto_avirario/app/domain/dto/dto_lote.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_lote.dart';

class ALote {
  final IDAOLote dao;
  final DTOLote dto;

  ALote({required this.dao, required this.dto});

  Future<DTOLote> salvarLote() async {
    return await dao.salvar(dto);
  }

  Future<void> deletarLote() async {
    await dao.deletar(dto.id);
  }

  static Future<ALote?> buscarLotePorId(IDAOLote dao, dynamic id) async {
    final dto = await dao.buscarPorId(id);
    if (dto != null) {
      return ALote(dao: dao, dto: dto);
    }
    return null;
  }

  static Future<List<ALote>> buscarTodosLotes(IDAOLote dao) async {
    final dtos = await dao.buscarTodos();
    return dtos.map((dto) => ALote(dao: dao, dto: dto)).toList();
  }
}
