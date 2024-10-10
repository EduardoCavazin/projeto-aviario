import 'package:flutter/material.dart';
import 'package:projeto_avirario/app/aplication/a_propriedade.dart';
import 'package:projeto_avirario/app/domain/dto/dto_propriedade.dart';

class CadastroPropriedade extends StatefulWidget {
  @override
  _CadastroPropriedadeState createState() => _CadastroPropriedadeState();
}

class _CadastroPropriedadeState extends State<CadastroPropriedade> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final localizacaoController = TextEditingController();
  final qtdAviarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Propriedade')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome da Propriedade'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: localizacaoController,
                decoration: InputDecoration(labelText: 'Localização'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a localização';
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Cria o DTO de propriedade
                    final propriedadeDTO = DTOPropriedade(
                      nome: nomeController.text,
                      localizacao: localizacaoController.text,
                      qtdAviario: int.parse(qtdAviarioController.text),
                    );

                    // Cria a instância de APropriedade e salva no banco de dados
                    final propriedadeApp = APropriedade(dto: propriedadeDTO);
                    
                    try {
                      await propriedadeApp.salvar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Propriedade cadastrada com sucesso!')),
                      );
                      Navigator.pop(context);  // Retorna à tela anterior
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao cadastrar a propriedade: $e')),
                      );
                    }
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
