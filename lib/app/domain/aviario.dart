import 'package:projeto_avirario/app/domain/config/padroesAviarios.dart';
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
        capacidade = dto.capacidade {
    nomeAviario();
    capacidadeAviario();
  }

  Future<DTOAviario> salvar(IDAOAviario dao) async {
    return await dao.salvar(DTOAviario(
      id: id,
      nome: nome,
      capacidade: capacidade,
    ));
  }

  Future<void> deletar(IDAOAviario dao) async {
    await dao.deletar(id);
  }

  static Future<Aviario?> buscarPorId(IDAOAviario dao, dynamic id) async {
    final dto = await dao.buscarPorId(id);
    if (dto != null) {
      return Aviario(dto: dto);
    }
    return null;
  }

  static Future<List<Aviario>> buscarTodos(IDAOAviario dao) async {
    final dtos = await dao.buscarTodos();
    return dtos.map((dto) => Aviario(dto: dto)).toList();
  }

  Future<void> atualizarDados({
  required IDAOAviario dao,
  required String novoNome,
  required int novaCapacidade,
}) async {
  nome = novoNome;
  capacidade = novaCapacidade;
  await salvar(dao);
}

  void gerarRelatorio() {
    // TODO: Lógica para relatório
  }

  void nomeAviario() {
    if (nome.isEmpty) {
      throw Exception('Nome do aviário não pode ser vazio');
    }
  }

  void capacidadeAviario() {
    if (capacidade < qtdMaxAves || capacidade > qtdMaxAves) {
      throw Exception('Quantidade de aves deve estar entre 18k e 80k');
    }
  }
}
