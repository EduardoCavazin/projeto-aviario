import 'package:projeto_avirario/app/domain/dto/dto_propriedade.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_propriedade.dart';
import 'package:projeto_avirario/app/domain/propriedade.dart';
import 'package:projeto_avirario/app/database/supabase/dao_propriedade_supabase.dart';

class APropriedade {
  Propriedade? propriedade;
  IDAOPropriedade dao;

  APropriedade({required DTOPropriedade dto, IDAOPropriedade? dao})
      : dao = dao ?? DAOPropriedadeSupabase() {
    propriedade = Propriedade(dto: dto);
  }

  APropriedade.withoutDTO({IDAOPropriedade? dao})
      : dao = dao ?? DAOPropriedadeSupabase() {
    propriedade = null;
  }

  Future<DTOPropriedade> salvar() async {
    if (propriedade == null) throw Exception("Propriedade não definida.");
    return await propriedade!.salvar(dao);
  }

  Future<void> deletar() async {
    if (propriedade == null) throw Exception("Propriedade não definida.");
    await propriedade!.deletarPropriedade(dao);
  }

  Future<Propriedade?> buscarPorId(dynamic id) async {
    final dto = await dao.buscarPorId(id);
    if (dto != null) {
      return Propriedade(dto: dto);
    }
    return null;
  }

  Future<List<Propriedade>> buscarPropriedades() async {
    final dtos = await dao.buscarPropriedade();
    return dtos.map((dto) => Propriedade(dto: dto)).toList();
  }
}
