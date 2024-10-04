import 'package:flutter/material.dart';
import 'package:projeto_avirario/widget/login.dart';
import 'package:projeto_avirario/widget/cadastro_usuário.dart';
import 'package:projeto_avirario/widget/lista_propriedade.dart'
;
class Routes {
  static const String login = '/';
  static const String cadastroUsuario = '/cadastro-usuario';
  static const String listaPropriedade = '/lista-propriedade';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => LoginScreen(),
      cadastroUsuario: (context) => CadastroUsuario(),
      listaPropriedade: (context) => ListaPropriedade(),
    };
  }
}
