import 'package:projeto_avirario/app/domain/dto/dto_aviario.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_aviario.dart';

class Aviario {
  dynamic id;
  String nome;
  int capacidade;

  Aviario({
    required DTOAviario dto,
  })  : id = dto.id,
        nome = dto.nome,
        capacidade = dto.capacidade
        {
    nomeAviario();
        }

  DTOAviario salvar(IDAOAviario dao) {
    return dao.salvar(DTOAviario(
      id: id,
      nome: nome,
      capacidade: capacidade
    ));
  }

  void deletar(IDAOAviario dao) {
    dao.deletar(id);
  }

  static Aviario? buscarPorId(IDAOAviario dao, dynamic id) {
    final dto = dao.buscarPorId(id);
    if (dto != null) {
      return Aviario(dto: dto);
    }
    return null;
  }

  static List<Aviario> buscarTodos(IDAOAviario dao) {
    return dao.buscarTodos().map((dto) => Aviario(dto: dto)).toList();
  }

  void atualizarDados({
    required String novoNome,
    required int novaCapacidade,
    required String novoTipo,
  }) {
    nome = novoNome;
    capacidade = novaCapacidade;
  }

  void gerarRelatorio() {
    // TODO: Lógica para relatório
  }

  void nomeAviario(){
    if(nome.isEmpty){
      throw Exception('Nome do aviário não pode ser vazio');
    }
  }

  void capacidadeAviario(){
    if(capacidade < 15000 && capacidade > 80000){
      throw Exception('Capacidade do aviário não pode ser menor que 15k ou maior que 80k');
    }
  }
}
