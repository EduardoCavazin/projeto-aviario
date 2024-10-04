import 'package:projeto_avirario/app/database/supabase/conexao_supabase.dart';
import 'package:projeto_avirario/app/domain/dto/dto_usuario.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_usuario.dart';

class DAOUsuarioSupabase implements IDAOUsuario {
  final supabase = DatabaseConnection().client;

  @override
  Future<DTOUsuario> salvar(DTOUsuario dto) async {
    if (dto.id == null) {
      // Inserção de novo usuário
      final response = await supabase.from('usuario').insert({
        'nome': dto.nome,
        'email': dto.email,
        'senha': dto.senha,
      }).select();

      if (response.isEmpty) {
        throw Exception('Erro ao salvar o usuário');
      }

      final data = response[0] as Map<String, dynamic>;
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

      if (response.isEmpty) {
        throw Exception('Erro ao atualizar o usuário');
      }

      return dto;
    }
  }

  @override
  Future<void> deletar(dynamic id) async {
    final response = await supabase.from('usuario').delete().eq('id', id);

    if (response.error != null) {
      throw Exception('Erro ao deletar o usuário');
    }
  }

  @override
  Future<DTOUsuario?> buscarPorId(dynamic id) async {
    final response =
        await supabase.from('usuario').select().eq('id', id).single();

    if (response.isNotEmpty) {
      throw Exception('Erro ao buscar o usuário');
    }

    final data = response.entries as Map<String, dynamic>;
    return DTOUsuario(
      id: data['id'],
      nome: data['nome'],
      email: data['email'],
      senha: data['senha'],
    );
  }

  @override
  Future<List<DTOUsuario>> buscarUsuarios() async {
    final response = await supabase.from('usuario').select();

    if (response.isEmpty) {
      throw Exception('Erro ao buscar usuários');
    }

    final List<dynamic> data = response as List<dynamic>;
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

    @override
  Future<DTOUsuario?> buscarPorEmail(String email) async {
    final response = await supabase
        .from('usuario')
        .select()
        .eq('email', email)
        .single();

    if (response['data'] != null) {
      final data = response.entries as Map<String, dynamic>;
      
      return DTOUsuario(
        id: data['id'] as int,
        nome: data['nome'] as String,
        email: data['email'] as String,
        senha: data['senha'] as String,
      );
    }
    return null;
  }

}
