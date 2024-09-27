import 'package:flutter/material.dart';
import 'package:projeto_avirario/app/domain/dto/dto_propriedade.dart';

class ListaPropriedade extends StatelessWidget {
  
  Future<List<DTOPropriedade>> consultar() async {
    return[
      DTOPropriedade(nome: 'Estancia 1', localizacao: 'Pvai', qtdAviario: 15),
      DTOPropriedade(nome: 'Estancia 2', localizacao: 'NAI', qtdAviario: 4),
      DTOPropriedade(nome: 'Estancia 3', localizacao: 'PSO', qtdAviario: 6),
    ];
  }

  Widget createButton(BuildContext context, String route, String text) {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, route),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Propriedades'),
      ),
      body: FutureBuilder(
        future: consultar(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var dados = snapshot.data;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Indicador de carregamento
          }

          if (!snapshot.hasData || dados == null || dados.isEmpty) {
            return Center(child: Text('Nenhum dado encontrado'));
          } else {
            return ListView.builder(
              itemCount: dados.length,
              itemBuilder: (context, index) {
                var propriedade = dados[index];
                return ListTile(
                  leading: Icon(Icons.home),
                  title: Text(propriedade.nome),
                  subtitle: Text('Localização: ${propriedade.localizacao}'),
                  trailing: Text('Aviários: ${propriedade.qtdAviario}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
