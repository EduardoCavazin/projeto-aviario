import 'package:projeto_avirario/app/domain/dto/dto_aviario.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_aviario.dart';

class AAviario {
  final IDAOAviario dao;
  final DTOAviario dto;

  AAviario({required this.dao, required this.dto});

  Future<DTOAviario> salvarAviario() async {
    return await dao.salvar(dto);
  }

  Future<void> deletarAviario() async {
    await dao.deletar(dto.id);
  }

  static Future<AAviario?> buscarAviarioPorId(IDAOAviario dao, dynamic id) async {
    final dto = await dao.buscarPorId(id);
    if (dto != null) {
      return AAviario(dao: dao, dto: dto);
    }
    return null;
  }

  static Future<List<AAviario>> buscarTodosAviarios(IDAOAviario dao) async {
    final dtos = await dao.buscarTodos();
    return dtos.map((dto) => AAviario(dao: dao, dto: dto)).toList();
  }
}
