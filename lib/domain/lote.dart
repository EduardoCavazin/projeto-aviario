import 'package:projeto_avirario/domain/dto/dto_lote.dart';
import 'package:projeto_avirario/domain/interface/i_dao_lote.dart';

class Lote {
  dynamic id;
  DateTime dataEntrada;
  int quantidadeAves;
  double pesoMedio;
  double quantidadeRacaoInicial;

  Lote({
    required DTOLote dto,
  })  : id = dto.id,
        dataEntrada = dto.dataEntrada,
        quantidadeAves = dto.quantidadeAves,
        pesoMedio = dto.pesoMedio,
        quantidadeRacaoInicial = dto.quantidadeRacaoInicial;

  DTOLote salvar(IDAOLote dao) {
    return dao.salvar(DTOLote(
      id: id,
      dataEntrada: dataEntrada,
      quantidadeAves: quantidadeAves,
      pesoMedio: pesoMedio,
      quantidadeRacaoInicial: quantidadeRacaoInicial,
    ));
  }

  void deletar(IDAOLote dao) {
    dao.deletar(id);
  }

  static Lote? buscarPorId(IDAOLote dao, dynamic id) {
    final dto = dao.buscarPorId(id);
    if (dto != null) {
      return Lote(dto: dto);
    }
    return null;
  }

  static List<Lote> buscarTodos(IDAOLote dao) {
    return dao.buscarTodos().map((dto) => Lote(dto: dto)).toList();
  }

  void registrarDados({
    required int novasMortes,
    required double novoPesoMedio,
    required double novaQuantidadeRacao,
  }) {
    // Implementação do registro de dados
    quantidadeAves -= novasMortes;
    pesoMedio = novoPesoMedio;
    quantidadeRacaoInicial += novaQuantidadeRacao;
  }

  void atualizarDados({
    required DateTime novaDataEntrada,
    required int novaQuantidadeAves,
    required double novoPesoMedio,
    required double novaQuantidadeRacaoInicial,
  }) {
    dataEntrada = novaDataEntrada;
    quantidadeAves = novaQuantidadeAves;
    pesoMedio = novoPesoMedio;
    quantidadeRacaoInicial = novaQuantidadeRacaoInicial;
  }

  void gerarRelatorio() {
    // TODO: logica para gerar relatório
  }
}
