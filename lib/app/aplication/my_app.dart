import 'package:flutter/material.dart';
import 'package:projeto_avirario/widget/routes.dart'; 

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto Aviário',
      initialRoute: Routes.login,
      routes: Routes.getRoutes(), 
    );
  }
}
