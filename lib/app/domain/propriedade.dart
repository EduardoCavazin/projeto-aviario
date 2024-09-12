import 'package:projeto_avirario/app/domain/aviario.dart';
import 'package:projeto_avirario/app/domain/dto/dto_propriedade.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_propriedade.dart';

class Propriedade {
  dynamic id;
  String nome;
  String localizacao;
  int qtdAviario;
  List<Aviario> aviarios;

  Propriedade({required DTOPropriedade dto})
      : id = dto.id,
        nome = dto.nome,
        localizacao = dto.localizacao,
        qtdAviario = dto.qtdAviario,
        aviarios = dto.aviarios {
    _validarNome();
    _validarLocalizacao();
    _validarQtdAviarios();
  }

  Future<DTOPropriedade> salvar(IDAOPropriedade dao) async {
    return await dao.salvar(DTOPropriedade(
      id: id,
      nome: nome,
      localizacao: localizacao,
      qtdAviario: qtdAviario,
      aviarios: aviarios,
    ));
  }

  Future<void> deletarPropriedade(IDAOPropriedade dao) async {
    if (id == null) {
      throw Exception('Propriedade não pode ser deletada sem um ID válido.');
    }
    await dao.deletarPropriedade(id);
  }

  static Future<Propriedade?> buscarPorId(IDAOPropriedade dao, dynamic id) async {
    final dto = await dao.buscarPorId(id);
    if (dto != null) {
      return Propriedade(dto: dto);
    }
    return null;
  }

  static Future<List<Propriedade>> buscarPropriedade(IDAOPropriedade dao) async {
    final dtos = await dao.buscarPropriedade();
    return dtos.map((dto) => Propriedade(dto: dto)).toList();
  }

  void gerarRelatorio() {
    print('Relatório da Propriedade: $nome');
    print('Localização: $localizacao');
    print('Número de Aviários: $qtdAviario');
    print('Detalhes dos Aviários:');
    for (var aviario in aviarios) {
      aviario.gerarRelatorio();
    }
  }

  void addAviario(Aviario aviario) {
    aviarios.add(aviario);
    qtdAviario = aviarios.length;
  }

  void removeAviario(int index) {
    if (index >= 0 && index < aviarios.length) {
      aviarios.removeAt(index);
      qtdAviario = aviarios.length;
    } else {
      throw Exception('Índice do aviário inválido. Aviário não encontrado.');
    }
  }

  void editAviario(int index, Aviario aviario) {
    if (index >= 0 && index < aviarios.length) {
      aviarios[index] = aviario;
    } else {
      throw Exception('Índice do aviário inválido. Aviário não encontrado.');
    }
  }

  List<Aviario> visualizarAviarios() {
    return List.unmodifiable(aviarios);
  }

  // Validações privadas
  void _validarNome() {
    if (nome.trim().isEmpty) {
      throw Exception('Nome da propriedade não pode ser vazio');
    }
  }

  void _validarLocalizacao() {
    if (localizacao.trim().isEmpty) {
      throw Exception('Localização da propriedade não pode ser vazia');
    }
  }

  void _validarQtdAviarios() {
    if (qtdAviario <= 0) {
      throw Exception('A quantidade de aviários deve ser maior que zero.');
    }
  }
}
