import 'package:flutter/material.dart';
import 'package:projeto_avirario/app/database/supabase/dao_usuario_supabase.dart';
import 'package:projeto_avirario/widget/routes.dart';
import 'package:projeto_avirario/app/domain/dto/dto_usuario.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DAOUsuarioSupabase daoUsuario = DAOUsuarioSupabase();

  Future<void> _login(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    final email = emailController.text;
    final senha = passwordController.text;

    try {
      DTOUsuario? usuario = await daoUsuario.buscarPorEmail(email);

      print('Senha do banco: ${usuario?.senha}, Senha inserida: $senha');

      if (usuario != null && usuario.senha == senha) {
        Navigator.pushNamed(context, Routes.listaPropriedade);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email ou senha incorretos!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login: $e')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  }
                  if (!value.contains('@')) {
                    return 'Insira um email válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  if (value.length < 6) {
                    return 'A senha deve ter no mínimo 6 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _login(context),
                child: Text('Login'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, Routes.cadastroUsuario);
                },
                child: Text('Não tem uma conta? Registre-se aqui!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
