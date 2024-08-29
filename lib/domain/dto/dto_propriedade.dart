import 'package:projeto_avirario/domain/aviario.dart';

class DTOPropriedade {
  dynamic id;
  String nome;
  String localizacao;
  int qtdAviario;
  List<Aviario> aviarios;

  DTOPropriedade({
    this.id,
    required this.nome,
    required this.localizacao,
    required this.qtdAviario,
    List<Aviario>? aviarios,
  }) : aviarios = aviarios ?? <Aviario>[];
}
