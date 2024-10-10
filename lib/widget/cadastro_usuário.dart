import 'package:flutter/material.dart';
import 'package:projeto_avirario/app/aplication/a_usuario.dart';
import 'package:projeto_avirario/app/aplication/a_propriedade.dart';
import 'package:projeto_avirario/app/domain/dto/dto_usuario.dart';
import 'package:projeto_avirario/app/domain/dto/dto_propriedade.dart';
import 'package:projeto_avirario/widget/routes.dart';

class CadastroUsuario extends StatefulWidget {
  @override
  _CadastroUsuario createState() => _CadastroUsuario();
}

class _CadastroUsuario extends State<CadastroUsuario> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final nomePropriedadeController = TextEditingController();
  final localizacaoPropriedadeController = TextEditingController();
  final qtdAviarioController = TextEditingController();

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final usuarioDTO = DTOUsuario(
        nome: nomeController.text,
        email: emailController.text,
        senha: senhaController.text,
      );

      final usuarioApp = AUsuario(dto: usuarioDTO);

      final propriedadeDTO = DTOPropriedade(
        nome: nomePropriedadeController.text,
        localizacao: localizacaoPropriedadeController.text,
        qtdAviario: int.parse(qtdAviarioController.text),
      );

      final propriedadeApp = APropriedade(dto: propriedadeDTO);

      try {
        await usuarioApp.salvar();
        await propriedadeApp.salvar();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário e propriedade cadastrados com sucesso!')),
        );

        Navigator.pushNamed(context, Routes.listaPropriedade);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro de Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o email';
                  }
                  if (!value.contains('@')) {
                    return 'Insira um email válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: senhaController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a senha';
                  }
                  if (value.length < 6) {
                    return 'A senha deve ter no mínimo 6 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nomePropriedadeController,
                decoration: InputDecoration(labelText: 'Nome da Propriedade'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da propriedade';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: localizacaoPropriedadeController,
                decoration: InputDecoration(labelText: 'Localização da Propriedade'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a localização da propriedade';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: qtdAviarioController,
                decoration: InputDecoration(labelText: 'Quantidade de Aviários'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade de aviários';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                child: Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
