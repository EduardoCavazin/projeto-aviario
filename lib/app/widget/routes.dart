import 'package:flutter/material.dart';
import 'package:projeto_ddm/app/widget/home_screen.dart';
import 'package:projeto_ddm/app/widget/auth/register_screen.dart';
import 'package:projeto_ddm/app/widget/auth/login_screen.dart';
import 'package:projeto_ddm/app/widget/property/property_screen.dart';

class Routes {
  static const String home = '/';
  static const String login = '/login';
  static const String cadastroUsuario = '/cadastro-usuario';
  static const String propriedade = '/propriedade';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => HomeScreen(),
      cadastroUsuario: (context) => RegisterScreen(),
      login: (context) => LoginScreen(),
      propriedade: (context) => PropertyScreen(),
    };
  }
}
