import 'package:projeto_avirario/app/domain/dto/dto_usuario.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_usuario.dart';
import 'package:projeto_avirario/app/domain/usuario.dart';
import 'package:projeto_avirario/app/database/sqlite/dao_usuario.dart';

class AUsuario {
  late Usuario usuario;
  IDAOUsuario dao = DAOUsuario();

  AUsuario({required DTOUsuario dto}) {
    usuario = Usuario(dto: dto);
  }

  Future<DTOUsuario> salvar() async {
    return await usuario.salvar(dao);
  }

  Future<void> deletar() async {
    usuario.deletar(dao);
  }

  static Future<Usuario?> buscarPorId(dynamic id) async {
    final dto = await DAOUsuario().buscarPorId(id);
    if (dto != null) {
      return Usuario(dto: dto);
    }
    return null;
  }

  static Future<List<Usuario>> buscarUsuarios() async {
    final dtos = await DAOUsuario().buscarUsuarios();
    return dtos.map((dto) => Usuario(dto: dto)).toList();
  }
}
