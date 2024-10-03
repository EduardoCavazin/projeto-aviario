import 'package:postgrest/src/types.dart';
import 'package:projeto_avirario/app/database/supabase/conexao_supabase.dart';
import 'package:projeto_avirario/app/domain/dto/dto_propriedade.dart';

class DAOPropriedadeSupabase {
  final supabase = DatabaseConnection().client;

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
Future<void> deletarPropriedade(dynamic id) async {
  final response = await supabase
      .from('propriedade')
      .delete()
      .eq('id', id);

  if (response.hasError) {
    throw Exception('Erro ao deletar a propriedade: ${response.error?.message}');
      }
    }
    
    Future<DTOPropriedade?> buscarPorId(dynamic id) async {
      final response = await supabase
          .from('propriedade')
          .select()
          .eq('id', id)
          .single(); 
    
      if (response.error != null) {
        throw Exception('Erro ao buscar a propriedade: ${response.error?.message}');
      }
    
      final data = response.data as Map<String, dynamic>?;
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
    
    Future<List<DTOPropriedade>> buscarPropriedade() async {
      final response = await supabase.from('propriedade').select();
    
      if (response.error != null) {
        throw Exception('Erro ao buscar propriedades: ${response.error?.message}');
      }
    
      final data = response.data as List<dynamic>?;
      if (data == null) {
        return [];
      }
    
      return data.map((item) {
        final map = item as Map<String, dynamic>;
        return DTOPropriedade(
          id: map['id'] as int,
          nome: map['nome'] as String,
          localizacao: map['localizacao'] as String,
          qtdAviario: map['qtdAviario'] as int,
          aviarios: [], 
        );
      }).toList();
    }
}

extension on PostgrestList {
  get error => null;
  
  get data => null;
}

extension on PostgrestMap {
  get error => null;
  
  get data => null;
}
