import 'package:flutter/material.dart';
import 'package:projeto_ddm/app/widget/routes.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo ao Projeto Aviário'),
        backgroundColor: const Color(0xFF2942A2), 
      ),
      body: Container(
        color: const Color(0xFF18234E), 
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.login);
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.cadastroUsuario);
                },
                child: const Text('Cadastro de Usuário'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
