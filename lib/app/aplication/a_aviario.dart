import 'package:projeto_avirario/app/domain/dto/dto_aviario.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_aviario.dart';
import 'package:projeto_avirario/app/database/supabase/dao_aviario_supabase.dart';

class AAviario {
  final IDAOAviario dao;
  final DTOAviario dto;

  AAviario({required this.dto, IDAOAviario? dao}) : dao = dao ?? DAOAviarioSupabase();

  Future<DTOAviario> salvarAviario() async {
    return await dao.salvar(dto);
  }

  Future<void> deletarAviario() async {
    await dao.deletar(dto.id);
  }

  Future<AAviario?> buscarAviarioPorId(dynamic id) async {
    final dto = await dao.buscarPorId(id);
    if (dto != null) {
      return AAviario(dto: dto, dao: dao);
    }
    return null;
  }

  Future<List<AAviario>> buscarTodosAviarios() async {
    final dtos = await dao.buscarTodos();
    return dtos.map((dto) => AAviario(dto: dto, dao: dao)).toList();
  }
}
