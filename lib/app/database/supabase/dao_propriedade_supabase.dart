import 'package:postgrest/src/types.dart';
import 'package:projeto_avirario/app/database/supabase/conexao_supabase.dart';
import 'package:projeto_avirario/app/domain/dto/dto_propriedade.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_propriedade.dart'; 

class DAOPropriedadeSupabase implements IDAOPropriedade {
  final supabase = DatabaseConnection().client;

  @override
  Future<DTOPropriedade> salvar(DTOPropriedade dto) async {
    if (dto.id == null) {
      final response = await supabase
          .from('propriedade')
          .insert({
            'nome': dto.nome,
            'localizacao': dto.localizacao,
            'qtdAviario': dto.qtdAviario,
          })
          .select();

      if (response.isNotEmpty) {
        final data = response[0];
        return DTOPropriedade(
          id: data['id'],
          nome: data['nome'],
          localizacao: data['localizacao'],
          qtdAviario: data['qtdAviario'],
          aviarios: dto.aviarios,
        );
      } else {
        throw Exception('Erro ao salvar a propriedade');
      }
    } else {
      final response = await supabase
          .from('propriedade')
          .update({
            'nome': dto.nome,
            'localizacao': dto.localizacao,
            'qtdAviario': dto.qtdAviario,
          })
          .eq('id', dto.id)
          .select();

      if (response.isNotEmpty) {
        return dto;
      } else {
        throw Exception('Erro ao atualizar a propriedade');
      }
    }
  }

  @override
  Future<void> deletarPropriedade(dynamic id) async {
  final response = await supabase.from('propriedade').delete().eq('id', id).select();

  if (response.error != null) {
    throw Exception('Erro ao deletar a propriedade');
  }
}

  @override
  Future<DTOPropriedade?> buscarPorId(dynamic id) async {
    final response = await supabase
        .from('propriedade')
        .select()
        .eq('id', id)
        .single();

    if (response.isEmpty) {
      throw Exception('Erro ao buscar a propriedade');
    }

    final data = response.entries as Map<String, dynamic>?;
    if (data == null) {
      return null;
    }

    return DTOPropriedade(
      id: data['id'] as int,
      nome: data['nome'] as String,
      localizacao: data['localizacao'] as String,
      qtdAviario: data['qtdAviario'] as int,
      aviarios: [],
    );
  }

  @override
  Future<List<DTOPropriedade>> buscarPropriedade() async {
    final response = await supabase
        .from('propriedade')
        .select();

    if (response.isEmpty) {
      throw Exception('Erro ao buscar propriedades');
    }

    final data = response as List<dynamic>;
    return data.map((item) {
      final map = item as Map<String, dynamic>;
      return DTOPropriedade(
        id: map['id'] as int,
        nome: map['nome'] as String,
        localizacao: map['localizacao'] as String,
        qtdAviario: map['qtdAviario'] as int,
      );
    }).toList();
  }
}

extension on PostgrestList {
  get error => null;
}
