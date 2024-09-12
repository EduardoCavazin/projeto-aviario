import 'package:projeto_avirario/app/domain/dto/dto_propriedade.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_propriedade.dart';
import 'package:projeto_avirario/app/domain/propriedade.dart';
import 'package:projeto_avirario/app/database/sqlite/dao_propriedade.dart';

class APropriedade {
  late Propriedade propriedade;
  IDAOPropriedade dao = DAOPropriedade();

  APropriedade({required DTOPropriedade dto}) {
    propriedade = Propriedade(dto: dto);
  }

  Future<DTOPropriedade> salvar() async {
    return await propriedade.salvar(dao);
  }

  Future<void> deletar() async {
    propriedade.deletarPropriedade(dao);
  }

  static Future<Propriedade?> buscarPorId(dynamic id) async {
    final dto = await DAOPropriedade().buscarPorId(id);
    if (dto != null) {
      return Propriedade(dto: dto);
    }
    return null;
  }

  static Future<List<Propriedade>> buscarPropriedades() async {
    final dtos = await DAOPropriedade().buscarPropriedade();
    return dtos.map((dto) => Propriedade(dto: dto)).toList();
  }
}
