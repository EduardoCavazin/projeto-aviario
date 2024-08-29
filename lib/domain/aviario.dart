import 'package:projeto_avirario/domain/dto/dto_aviario.dart';
import 'package:projeto_avirario/domain/interface/i_dao_aviario.dart';

class Aviario {
  dynamic id;
  String nome;
  int capacidade;
  String tipo;

  Aviario({
    required DTOAviario dto,
  })  : id = dto.id,
        nome = dto.nome,
        capacidade = dto.capacidade,
        tipo = dto.tipo;

  DTOAviario salvar(IDAOAviario dao) {
    return dao.salvar(DTOAviario(
      id: id,
      nome: nome,
      capacidade: capacidade,
      tipo: tipo,
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
    tipo = novoTipo;
  }

  void gerarRelatorio() {
    // TODO: Lógica para relatório
  }
}
