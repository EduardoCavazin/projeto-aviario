import 'package:flutter/material.dart';
import 'package:projeto_avirario/app/domain/dto/dto_propriedade.dart';
import 'package:projeto_avirario/app/aplication/a_propriedade.dart';
import 'package:projeto_avirario/app/domain/propriedade.dart';
import 'package:projeto_avirario/widget/cadastro_propriedade.dart';

class ListaPropriedade extends StatelessWidget {
  Future<List<DTOPropriedade>> consultar() async {
    APropriedade aPropriedade = APropriedade(dto: DTOPropriedade(nome: '', localizacao: '', qtdAviario: 0));
    List<Propriedade> propriedadesApp = await aPropriedade.buscarPropriedades();
    List<DTOPropriedade> dtoPropriedades = propriedadesApp.map((propriedade) {
      return DTOPropriedade(
        nome: propriedade.nome,
        localizacao: propriedade.localizacao,
        qtdAviario: propriedade.qtdAviario,
      );
    }).toList();

    return dtoPropriedades;
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
