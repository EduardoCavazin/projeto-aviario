import 'package:projeto_avirario/domain/aviario.dart';

class Propriedade {

  String nome;
  String localizacao;
  int qtdAviario;
  List<Aviario> aviarios;

  Propriedade({
    required this.nome, 
    required this.localizacao, 
    required this.qtdAviario,
    List<Aviario>? aviarios,
    }) : aviarios = aviarios ?? <Aviario>[];

    void gerarRelatorio(){
      //TODO: Implementar
    }


}