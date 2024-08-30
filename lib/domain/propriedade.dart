import 'package:projeto_avirario/domain/aviario.dart';
import 'package:projeto_avirario/domain/dto/dto_propriedade.dart';
import 'package:projeto_avirario/domain/interface/i_dao_propriedade.dart';

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
        aviarios = dto.aviarios
        {
    nomeVazio();
    localizacaoVazia();
    
        }

  DTOPropriedade salvar(IDAOPropriedade dao) {
    return dao.salvar(DTOPropriedade(
      id: id,
      nome: nome,
      localizacao: localizacao,
      qtdAviario: qtdAviario,
      aviarios: aviarios,
    ));
  }

  void deletarPropriedade(IDAOPropriedade dao) {
    dao.deletarPropriedade(id);
  }

  static Propriedade? buscarPorId(IDAOPropriedade dao, dynamic id) {
    final dto = dao.buscarPorId(id);
    if (dto != null) {
      return Propriedade(dto: dto);
    }
    return null;
  }

  static List<Propriedade> buscarPropriedade(IDAOPropriedade dao) {
    return dao.buscarPropriedade().map((dto) => Propriedade(dto: dto)).toList();
  }

  void gerarRelatorio() {
    // Implementação básica do relatório
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
      throw Exception('Aviário não encontrado');
    }
  }

  void editAviario(int index, Aviario aviario) {
    if (index >= 0 && index < aviarios.length) {
      aviarios[index] = aviario;
    } else {
      throw Exception('Aviário não encontrado');
    }
  }

  List<Aviario> visualizarAviarios() {
    return List.unmodifiable(aviarios);
  }

  void nomeVazio(){
    if(nome.isEmpty){
      throw Exception('Nome da propriedade não pode ser vazio');
    }
  }

  void localizacaoVazia(){
    if(localizacao.isEmpty){
      throw Exception('Localização da propriedade não pode ser vazia');
    }
  }

  void qtdAviarioVazia(){
    if(qtdAviario <= 0){
      throw Exception('Quantidade de aviários não pode ser vazia');
    }
  }
}
