import 'package:projeto_avirario/app/domain/dto/dto_aviario.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_aviario.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DAOAviarioSupabase implements IDAOAviario {
  final supabase = Supabase.instance.client;

  @override
  Future<DTOAviario> salvar(DTOAviario dto) async {
    if (dto.id == null) {
      // Inserção de novo aviário
      final response = await supabase
          .from('aviario')
          .insert({
            'nome': dto.nome,
            'capacidade': dto.capacidade,
          })
          .select();

      if (response.error != null) {
        throw Exception('Erro ao salvar o aviário: ${response.error!.message}');
      }

      final data = response.data[0] as Map<String, dynamic>;
      dto.id = data['id'];
    } else {
      // Atualização de aviário existente
      final response = await supabase
          .from('aviario')
          .update({
            'nome': dto.nome,
            'capacidade': dto.capacidade,
          })
          .eq('id', dto.id)
          .select();

      if (response.error != null) {
        throw Exception('Erro ao atualizar o aviário: ${response.error!.message}');
      }
    }
    return dto;
  }

  @override
  Future<void> deletar(dynamic id) async {
    final response = await supabase.from('aviario').delete().eq('id', id);

    if (response.error != null) {
      throw Exception('Erro ao deletar o aviário: ${response.error!.message}');
    }
  }

  @override
  Future<DTOAviario?> buscarPorId(dynamic id) async {
    final response = await supabase
        .from('aviario')
        .select()
        .eq('id', id)
        .single();

    if (response.error != null) {
      throw Exception('Erro ao buscar o aviário: ${response.error!.message}');
    }

    if (response.data != null) {
      final data = response.data as Map<String, dynamic>;
      return DTOAviario(
        id: data['id'],
        nome: data['nome'],
        capacidade: data['capacidade'],
      );
    }
    return null;
  }

  @override
  Future<List<DTOAviario>> buscarTodos() async {
    final response = await supabase.from('aviario').select();

    if (response.error != null) {
      throw Exception('Erro ao buscar aviários: ${response.error!.message}');
    }

    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((aviario) {
      final map = aviario as Map<String, dynamic>;
      return DTOAviario(
        id: map['id'],
        nome: map['nome'],
        capacidade: map['capacidade'],
      );
    }).toList();
  }
}

extension on PostgrestMap {
  get error => null;
  
  get data => null;
}

extension on PostgrestList {
  get error => null;
  
  get data => null;
}
