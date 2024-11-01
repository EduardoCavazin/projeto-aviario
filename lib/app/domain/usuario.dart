import 'package:projeto_avirario/app/domain/dto/dto_usuario.dart';
import 'package:projeto_avirario/app/domain/propriedade.dart';

class Usuario {
  dynamic id;
  String nome;
  String email;
  List<Propriedade> propriedades;

  Usuario({
    required DTOUsuario dto,
    List<Propriedade>? propriedades,
  })  : id = dto.id,
        nome = dto.nome,
        email = dto.email,
        propriedades = propriedades ?? <Propriedade>[] {
    _validar();
  }

  void addPropriedade(Propriedade propriedade) {
    if (!propriedades.contains(propriedade)) {
      propriedades.add(propriedade);
    }
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

  void _validar() {
    _validarNome();
    _validarEmail();
  }

  void _validarNome() {
    if (nome.isEmpty) {
      throw Exception('Nome não pode ser vazio');
    }
  }

  void _validarEmail() {
    if (email.isEmpty) {
      throw Exception('Email não pode ser vazio');
    } else if (!email.contains('@')) {
      throw Exception('Email inválido');
    }
  }
}
