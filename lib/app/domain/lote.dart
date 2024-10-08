import 'package:projeto_avirario/app/domain/dto/dto_lote.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_lote.dart';
import 'package:projeto_avirario/app/domain/config/padroesAviarios.dart';

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
        qtdRacaoInicial = dto.qtdRacaoInicial{
    validarQtdAves();
    validarPesoMedio();
    validarQtdRacao();
    }

  Future<DTOLote> salvar(IDAOLote dao) async {
    return await dao.salvar(DTOLote(
      id: id,
      dataEntrada: dataEntrada,
      quantidadeAves: quantidadeAves,
      pesoMedio: pesoMedio,
      qtdRacaoInicial: qtdRacaoInicial,
    ));
  }

  Future<void> deletar(IDAOLote dao) async {
    await dao.deletar(id);
  }

  static Future<Lote?> buscarPorId(IDAOLote dao, dynamic id) async {
    final dto = await dao.buscarPorId(id);
    if (dto != null) {
      return Lote(dto: dto);
    }
    return null;
  }

  static Future<List<Lote>> buscarTodos(IDAOLote dao) async {
    final dtos = await dao.buscarTodos();
    return dtos.map((dto) => Lote(dto: dto)).toList();
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

  void gerarRelatorio() {
    // TODO: lógica para gerar relatório
  }

  void validarQtdAves() {
    if (quantidadeAves < qtdMinAves || quantidadeAves > qtdMaxAves) {
      throw Exception('Quantidade de aves deve estar entre 18k e 80k');
    }
  }

  void validarPesoMedio() {
    if (pesoMedio <= 0) {
      throw Exception('Peso médio deve ser maior que zero');
    }
  }

  void validarQtdRacao() {
    if (qtdRacaoInicial <= 0) {
      throw Exception('Quantidade de ração inicial deve ser maior que zero');
    }
  }
}
