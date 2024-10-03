import 'package:projeto_avirario/app/domain/dto/dto_usuario.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_usuario.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DAOUsuarioSupabase implements IDAOUsuario {
  final supabase = Supabase.instance.client;

  @override
  Future<DTOUsuario> salvar(DTOUsuario dto) async {
    if (dto.id == null) {
      // Inserção de novo usuário
      final response = await supabase
          .from('usuario')
          .insert({
            'nome': dto.nome,
            'email': dto.email,
            'senha': dto.senha,
          })
          .select();
          
      if (response.error != null) {
        throw Exception('Erro ao salvar o usuário: ${response.error!.message}');
      }

      final data = response.data[0] as Map<String, dynamic>;
      return DTOUsuario(
        id: data['id'],
        nome: data['nome'],
        email: data['email'],
        senha: data['senha'],
      );
    } else {
      // Atualização de usuário existente
      final response = await supabase
          .from('usuario')
          .update({
            'nome': dto.nome,
            'email': dto.email,
            'senha': dto.senha,
          })
          .eq('id', dto.id)
          .select();

      if (response.error != null) {
        throw Exception('Erro ao atualizar o usuário: ${response.error!.message}');
      }

      return dto;
    }
  }

  @override
  Future<void> deletar(dynamic id) async {
    final response = await supabase.from('usuario').delete().eq('id', id);

    if (response.error != null) {
      throw Exception('Erro ao deletar o usuário: ${response.error!.message}');
    }
  }

  @override
  Future<DTOUsuario?> buscarPorId(dynamic id) async {
    final response = await supabase
        .from('usuario')
        .select()
        .eq('id', id)
        .single();

    if (response.error != null) {
      throw Exception('Erro ao buscar o usuário: ${response.error!.message}');
    }

    if (response.data != null) {
      final data = response.data as Map<String, dynamic>;
      return DTOUsuario(
        id: data['id'],
        nome: data['nome'],
        email: data['email'],
        senha: data['senha'],
      );
    }
    return null;
  }

  @override
  Future<List<DTOUsuario>> buscarUsuarios() async {
    final response = await supabase.from('usuario').select();

    if (response.error != null) {
      throw Exception('Erro ao buscar usuários: ${response.error!.message}');
    }

    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((item) {
      final map = item as Map<String, dynamic>;
      return DTOUsuario(
        id: map['id'],
        nome: map['nome'],
        email: map['email'],
        senha: map['senha'],
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
