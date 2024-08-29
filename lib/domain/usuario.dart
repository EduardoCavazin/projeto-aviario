import 'package:projeto_avirario/domain/propriedade.dart';

class Usuario {

  String name;
  String email;
  String password;
  List<Propriedade> propriedades;

  Usuario({
    required this.name, 
    required this.email, 
    required this.password,
    List<Propriedade>? propriedades,
    }) : propriedades = propriedades ?? <Propriedade>[];

  void addPropriedade(Propriedade propriedade) {
    propriedades.add(propriedade);
  }

  void removePropriedade(int index) {
    if(index >= 0 && index < propriedades.length) {
      propriedades.removeAt(index);
    }else{
      throw Exception('Propriedade não encontrada');
    }
  }

  void editPropriedade(int index, Propriedade propriedade) {
    if(index >= 0 && index < propriedades.length) {
      propriedades[index] = propriedade;
    }else{
      throw Exception('Propriedade não encontrada');
    }
  }

  List<Propriedade> visualizarPropriedades(){
    return List.unmodifiable(propriedades);
  }

  void gerarRelatorio(){
    for(var propriedade in propriedades){
      propriedade.gerarRelatorio();
    }
  }
  
}