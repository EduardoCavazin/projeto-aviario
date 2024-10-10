import 'package:projeto_avirario/app/domain/dto/dto_usuario.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_usuario.dart';
import 'package:projeto_avirario/app/domain/usuario.dart';
import 'package:projeto_avirario/app/database/supabase/dao_usuario_supabase.dart';

class AUsuario {
  late Usuario usuario;
  IDAOUsuario dao;

  AUsuario({required DTOUsuario dto, IDAOUsuario? dao})
      : dao = dao ?? DAOUsuarioSupabase() {
    usuario = Usuario(dto: dto);
  }

  get senha => null;

  Future<DTOUsuario> salvar() async {
    return await usuario.salvar(dao);
  }

  Future<void> deletar() async {
    await usuario.deletar(dao);
  }

  Future<Usuario?> buscarPorId(dynamic id) async {
    final dto = await dao.buscarPorId(id);
    if (dto != null) {
      return Usuario(dto: dto);
    }
    return null;
  }

  Future<List<Usuario>> buscarUsuarios() async {
    final dtos = await dao.buscarUsuarios();
    return dtos.map((dto) => Usuario(dto: dto)).toList();
  }

  static Future<AUsuario?> buscarPorEmail(String email) async {
    final dao = DAOUsuarioSupabase();
    final dto = await dao.buscarPorEmail(email);
    if (dto != null) {
      return AUsuario(dto: dto, dao: dao);
    }
    return null;
  }
}
