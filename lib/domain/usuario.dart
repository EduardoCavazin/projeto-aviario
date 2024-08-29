import 'package:projeto_avirario/domain/propriedades.dart';

class Usuario {

  String name;
  String email;
  String password;
  List<Propriedades> propriedades;

  Usuario({
    required this.name, 
    required this.email, 
    required this.password,
    List<Propriedades>? propriedades,
    }) : propriedades = propriedades ?? <Propriedades>[];

  void addPropriedade(Propriedades propriedade) {
    propriedades.add(propriedade);
  }

  void removePropriedade(int index) {
    if(index >= 0 && index < propriedades.length) {
      propriedades.removeAt(index);
    }else{
      throw Exception('Propriedade não encontrada');
    }
  }

  void editPropriedade(int index, Propriedades propriedade) {
    if(index >= 0 && index < propriedades.length) {
      propriedades[index] = propriedade;
    }else{
      throw Exception('Propriedade não encontrada');
    }
  }

  List<Propriedades> visualizarPropriedades(){
    return List.unmodifiable(propriedades);
  }

  void gerarRelatorio(){
    for(var propriedade in propriedades){
      propriedade.gerarRelatorio();
    }
  }
  
}