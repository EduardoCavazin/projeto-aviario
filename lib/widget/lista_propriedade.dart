import 'package:flutter/material.dart';
import 'package:projeto_avirario/app/domain/dto/dto_propriedade.dart';
import 'package:projeto_avirario/app/aplication/a_propriedade.dart';
import 'package:projeto_avirario/app/database/supabase/dao_propriedade_supabase.dart';
import 'package:projeto_avirario/app/domain/propriedade.dart';
import 'package:projeto_avirario/widget/cadastro_propriedade.dart';

class ListaPropriedade extends StatefulWidget {
  @override
  _ListaPropriedadeState createState() => _ListaPropriedadeState();
}

class _ListaPropriedadeState extends State<ListaPropriedade> {
  Future<List<DTOPropriedade>> consultar() async {
    final aPropriedade = APropriedade.withoutDTO(dao: DAOPropriedadeSupabase());
    List<Propriedade> propriedadesApp = await aPropriedade.buscarPropriedades();
    return propriedadesApp.map((propriedade) => propriedade.dto).toList();
  }

  Future<void> _deletarPropriedade(dynamic id) async {
    try {
      final dao = DAOPropriedadeSupabase();
      await dao.deletarPropriedade(id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Propriedade deletada com sucesso!')),
      );

      setState(() {}); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar a propriedade: $e')),
      );
    }
  }

  Future<void> _editarPropriedade(DTOPropriedade propriedade) async {
    final nomeController = TextEditingController(text: propriedade.nome);
    final localizacaoController = TextEditingController(text: propriedade.localizacao);
    final qtdAviarioController = TextEditingController(text: propriedade.qtdAviario.toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Propriedade'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nomeController,
                  decoration: InputDecoration(labelText: 'Nome da Propriedade'),
                ),
                TextFormField(
                  controller: localizacaoController,
                  decoration: InputDecoration(labelText: 'Localização'),
                ),
                TextFormField(
                  controller: qtdAviarioController,
                  decoration: InputDecoration(labelText: 'Quantidade de Aviários'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                propriedade.nome = nomeController.text;
                propriedade.localizacao = localizacaoController.text;
                propriedade.qtdAviario = int.parse(qtdAviarioController.text);

                final propriedadeApp = APropriedade(dto: propriedade);
                await propriedadeApp.salvar();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Propriedade atualizada com sucesso!')),
                );

                Navigator.pop(context);
                setState(() {}); 
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Propriedades'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_home_work),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CadastroPropriedade()),
              );
            },
          )
        ],
      ),
      body: FutureBuilder<List<DTOPropriedade>>(
        future: consultar(),
        builder: (BuildContext context, AsyncSnapshot<List<DTOPropriedade>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma propriedade encontrada.'));
          } else {
            var dados = snapshot.data!;
            return ListView.builder(
              itemCount: dados.length,
              itemBuilder: (context, index) {
                var propriedade = dados[index];
                return ListTile(
                  leading: Icon(Icons.agriculture),
                  title: Text(propriedade.nome),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Localização: ${propriedade.localizacao}'),
                      Text('Aviários: ${propriedade.qtdAviario}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editarPropriedade(propriedade),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deletarPropriedade(propriedade.id),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
