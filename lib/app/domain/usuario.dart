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
    emailValido();
    senhaValida();
  }

  Future<DTOUsuario> salvar(IDAOUsuario dao) async {
    return await dao
        .salvar(DTOUsuario(id: id, nome: nome, email: email, senha: senha));
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

  static Future<Usuario?> buscarPorEmail(IDAOUsuario dao, String email) async {
    final dto = await dao.buscarPorEmail(email);
    if (dto != null) {
      return Usuario(dto: dto);
    }
    return null;
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

  void emailValido() {
    if (email.isEmpty) {
      throw Exception('Email não pode ser vazio');
    } else if (!email.contains('@')) {
      throw Exception('Email inválido');
    }
  }

  void senhaValida() {
    if (senha.isEmpty) {
      throw Exception('Senha não pode ser vazia');
    } else if (senha.length < 6) {
      throw Exception('Senha deve ter no mínimo 6 caracteres');
    } else if (!senha.contains(RegExp(r'[a-zA-Z]')) ||
        !senha.contains(RegExp(r'[0-9]'))) {
      throw Exception('Senha deve conter pelo menos um caractere e um número');
    }
  }
}
