import 'package:projeto_avirario/app/domain/dto/dto_usuario.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_usuario.dart';
import 'package:projeto_avirario/app/domain/propriedade.dart';

class Usuario {
  dynamic id;
  String nome;
  String email;
  String senha;
  List<Propriedade> propriedades;

  Usuario({
    required DTOUsuario dto,
    List<Propriedade>? propriedades,
  })  : id = dto.id,
        nome = dto.nome,
        email = dto.email,
        senha = dto.senha,
        propriedades = propriedades ?? <Propriedade>[] {
    nomeVazio();
    emailVazio();
    senhaVazia();
  }

  Future<DTOUsuario> salvar(IDAOUsuario dao) async {
    return await dao.salvar(DTOUsuario(id: id, nome: nome, email: email, senha: senha));
  }

  Future<void> deletar(IDAOUsuario dao) async {
    await dao.deletar(id);
  }

  static Future<Usuario?> buscarPorId(IDAOUsuario dao, dynamic id) async {
    final dto = await dao.buscarPorId(id);
    if (dto != null) {
      return Usuario(dto: dto);
    }
    return null;
  }

  static Future<List<Usuario>> buscarUsuarios(IDAOUsuario dao) async {
    final dtos = await dao.buscarUsuarios();
    return dtos.map((dto) => Usuario(dto: dto)).toList();
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

  void nomeVazio() {
    if (nome.isEmpty) {
      throw Exception('Nome não pode ser vazio');
    }
  }

  void emailVazio() {
    if (email.isEmpty) {
      throw Exception('Email não pode ser vazio');
    }
  }

  void senhaVazia() {
    if (senha.isEmpty) {
      throw Exception('Senha não pode ser vazia');
    }
  }
}
