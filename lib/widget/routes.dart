import 'package:flutter/material.dart';
import 'package:projeto_avirario/widget/cadastro_usuário.dart';
import 'package:projeto_avirario/widget/lista_propriedade.dart'
;
class Routes {
  static const String cadastroUsuario = '/';
  static const String listaPropriedade = '/lista-propriedade';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      cadastroUsuario: (context) => CadastroUsuario(),
      listaPropriedade: (context) => ListaPropriedade(),
    };
  }
}
