import 'package:flutter/material.dart';
import 'package:projeto_avirario/app/aplication/a_usuario.dart';
import 'package:projeto_avirario/app/aplication/a_propriedade.dart';
import 'package:projeto_avirario/app/domain/dto/dto_usuario.dart';
import 'package:projeto_avirario/app/domain/dto/dto_propriedade.dart';

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
      // Criando DTO para o usuário
      final usuarioDTO = DTOUsuario(
        nome: nomeController.text,
        email: emailController.text,
        senha: senhaController.text,
      );

      // Criando a instância AUsuario para manipular o usuário
      final usuarioApp = AUsuario(dto: usuarioDTO);

      // Criando DTO para a propriedade
      final propriedadeDTO = DTOPropriedade(
        nome: nomePropriedadeController.text,
        localizacao: localizacaoPropriedadeController.text,
        qtdAviario: int.parse(qtdAviarioController.text),
      );

      // Criando a instância APropriedade para manipular a propriedade
      final propriedadeApp = APropriedade(dto: propriedadeDTO);

      try {
        // Salvando usuário usando AUsuario
        await usuarioApp.salvar();

        // Salvando propriedade usando APropriedade
        await propriedadeApp.salvar();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário e propriedade cadastrados com sucesso!')),
        );

        Navigator.pop(context);
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
              // Campos de registro da propriedade
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
