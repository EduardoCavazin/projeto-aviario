import 'package:flutter/material.dart';
import 'package:projeto_avirario/widget/cadastro_propriedade.dart';
import 'package:projeto_avirario/widget/lista_propriedade.dart';
import 'package:projeto_avirario/widget/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Projeto Aviário',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        routes: {
          Routes.home:  (context) => ListaPropriedade(),
          Routes.registerPropety: (context) => CadastroPropriedade(),
        });
  }
}
