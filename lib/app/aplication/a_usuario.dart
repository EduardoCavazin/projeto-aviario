import 'package:projeto_avirario/app/domain/dto/dto_usuario.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_usuario.dart';
import 'package:projeto_avirario/app/domain/usuario.dart';
import 'package:projeto_avirario/app/database/firebase/dao_usuario.dart';

class AUsuario {
  late Usuario usuario;
  IDAOUsuario dao;

  AUsuario({required DTOUsuario dto, IDAOUsuario? dao})
      : dao = dao ?? DAOUsuario() { 
    usuario = Usuario(dto: dto);
  }

  Future<DTOUsuario> salvar({required String senha}) async {
    return await dao.salvar(
      DTOUsuario(id: usuario.id, nome: usuario.nome, email: usuario.email),
      senha: senha,
    );
  }

  Future<void> deletar() async {
    await dao.deletar(usuario.id);
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
    final dao = DAOUsuario();
    final dto = await dao.buscarPorEmail(email);
    if (dto != null) {
      return AUsuario(dto: dto, dao: dao);
    }
    return null;
  }
}
