import 'package:flutter/material.dart';
import 'package:projeto_ddm/app/widget/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto Aviário',
      initialRoute: Routes.home, 
      routes: Routes.getRoutes(),
    );
  }
}
