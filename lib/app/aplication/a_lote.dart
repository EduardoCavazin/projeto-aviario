import 'package:projeto_avirario/app/domain/dto/dto_lote.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_lote.dart';
import 'package:projeto_avirario/app/database/supabase/dao_lote_supabase.dart';

class ALote {
  final IDAOLote dao;
  final DTOLote dto;

  ALote({required this.dto, IDAOLote? dao}) : dao = dao ?? DAOLoteSupabase();

  Future<DTOLote> salvarLote() async {
    return await dao.salvar(dto);
  }

  Future<void> deletarLote() async {
    await dao.deletar(dto.id);
  }

  Future<ALote?> buscarLotePorId(dynamic id) async {
    final dto = await dao.buscarPorId(id);
    if (dto != null) {
      return ALote(dto: dto, dao: dao);
    }
    return null;
  }

  Future<List<ALote>> buscarTodosLotes() async {
    final dtos = await dao.buscarTodos();
    return dtos.map((dto) => ALote(dto: dto, dao: dao)).toList();
  }
}
