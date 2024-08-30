import 'package:projeto_avirario/domain/dto/dto_usuario.dart';
import 'package:projeto_avirario/domain/interface/i_dao_usuario.dart';
import 'package:projeto_avirario/domain/propriedade.dart';

class Usuario {
  dynamic id;
  String nome;
  String email;
  String senha;
  List<Propriedade> propriedades;

  Usuario({required DTOUsuario dto, List<Propriedade>? propriedades})
      : id = dto.id,
        nome = dto.nome,
        email = dto.email,
        senha = dto.senha,
        propriedades = propriedades ?? <Propriedade>[];

  DTOUsuario salvar(IDAOUsuario dao) {
    return dao.salvar(DTOUsuario(id: id, nome: nome, email: email, senha: senha));
  }

  void deletar(IDAOUsuario dao) {
    dao.deletar(id);
  }

  static Usuario? buscarPorId(IDAOUsuario dao, dynamic id) {
    final dto = dao.buscarPorId(id);
    if (dto != null) {
      return Usuario(dto: dto);
    }
    return null;
  }

  static List<Usuario> buscarUsuarios(IDAOUsuario dao) {
    return dao.buscarUsuarios().map((dto) => Usuario(dto: dto)).toList();
  }

  void addPropriedade(Propriedade propriedade) {
    propriedades.add(propriedade);
  }

  void removePropriedade(int index) {
    if (index >= 0 && index < propriedades.length) {
      propriedades.removeAt(index);
    } else {
      throw Exception('Propriedade não encontrada');
    }
  }

  void editPropriedade(int index, Propriedade propriedade) {
    if (index >= 0 && index < propriedades.length) {
      propriedades[index] = propriedade;
    } else {
      throw Exception('Propriedade não encontrada');
    }
  }

  List<Propriedade> visualizarPropriedades() {
    return List.unmodifiable(propriedades);
  }

  void gerarRelatorio() {
    for (var propriedade in propriedades) {
      propriedade.gerarRelatorio();
    }
  }
}
