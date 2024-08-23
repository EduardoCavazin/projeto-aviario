import 'package:projeto_avirario/domain/aviario.dart';

class Propriedades {

  String nome;
  String localizacao;
  int qtdAviario;
  List<Aviario> aviarios;

  Propriedades({
    required this.nome, 
    required this.localizacao, 
    required this.qtdAviario,
    List<Aviario>? aviarios,
    }) : aviarios = aviarios ?? <Aviario>[];

    void gerarRelatorio(){
      //TODO: Implementar
    }


}