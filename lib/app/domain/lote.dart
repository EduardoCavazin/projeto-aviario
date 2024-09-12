import 'package:projeto_avirario/app/domain/dto/dto_lote.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_lote.dart';

class Lote {
  dynamic id;
  DateTime dataEntrada;
  int quantidadeAves;
  double pesoMedio;
  double qtdRacaoInicial;

  Lote({
    required DTOLote dto,
  })  : id = dto.id,
        dataEntrada = dto.dataEntrada,
        quantidadeAves = dto.quantidadeAves,
        pesoMedio = dto.pesoMedio,
        qtdRacaoInicial = dto.qtdRacaoInicial;

  DTOLote salvar(IDAOLote dao) {
    return dao.salvar(DTOLote(
      id: id,
      dataEntrada: dataEntrada,
      quantidadeAves: quantidadeAves,
      pesoMedio: pesoMedio,
      qtdRacaoInicial: qtdRacaoInicial,
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
    qtdRacaoInicial += novaQuantidadeRacao;
  }

  void atualizarDados({
    required DateTime novaDataEntrada,
    required int novaQuantidadeAves,
    required double novoPesoMedio,
    required double novaqtdRacaoInicial,
  }) {
    dataEntrada = novaDataEntrada;
    quantidadeAves = novaQuantidadeAves;
    pesoMedio = novoPesoMedio;
    qtdRacaoInicial = novaqtdRacaoInicial;
  }

  void gerarRelatorio() {
    // TODO: logica para gerar relatório
  }

  void qtdAvesVazia() {
    if (quantidadeAves <= 15000 && quantidadeAves < 80000) {
      throw Exception('Quantidade de aves deve estar entre 15k e 80k');
    }
  }

  void pesoMedioVazio() {
    if (pesoMedio <= 0) {
      throw Exception('Peso médio deve ser maior que zero');
    }
  }

  void qtdRacaoInicialVazia() {
    if (qtdRacaoInicial <= 0 ) {
      throw Exception('Quantidade de ração inicial deve ser maior que zero');
    }
  }
  
}
