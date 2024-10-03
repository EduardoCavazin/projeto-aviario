import 'package:projeto_avirario/app/domain/dto/dto_lote.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_lote.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DAOLoteSupabase implements IDAOLote {
  final supabase = Supabase.instance.client;

  @override
  Future<DTOLote> salvar(DTOLote dto) async {
    if (dto.id == null) {
      // Inserção de novo lote
      final response = await supabase
          .from('lote')
          .insert({
            'dataEntrada': dto.dataEntrada.toIso8601String(),
            'quantidadeAves': dto.quantidadeAves,
            'pesoMedio': dto.pesoMedio,
            'qtdRacaoInicial': dto.qtdRacaoInicial,
          })
          .select();

      if (response.error != null) {
        throw Exception('Erro ao salvar o lote: ${response.error!.message}');
      }

      final data = response.data[0] as Map<String, dynamic>;
      return DTOLote(
        id: data['id'],
        dataEntrada: DateTime.parse(data['dataEntrada']),
        quantidadeAves: data['quantidadeAves'],
        pesoMedio: data['pesoMedio'],
        qtdRacaoInicial: data['qtdRacaoInicial'],
      );
    } else {
      // Atualização de lote existente
      final response = await supabase
          .from('lote')
          .update({
            'dataEntrada': dto.dataEntrada.toIso8601String(),
            'quantidadeAves': dto.quantidadeAves,
            'pesoMedio': dto.pesoMedio,
            'qtdRacaoInicial': dto.qtdRacaoInicial,
          })
          .eq('id', dto.id)
          .select();

      if (response.error != null) {
        throw Exception('Erro ao atualizar o lote: ${response.error!.message}');
      }

      return dto;
    }
  }

  @override
  Future<DTOLote?> buscarPorId(dynamic id) async {
    final response = await supabase
        .from('lote')
        .select()
        .eq('id', id)
        .single();

    if (response.error != null) {
      throw Exception('Erro ao buscar o lote: ${response.error!.message}');
    }

    if (response.data != null) {
      final data = response.data as Map<String, dynamic>;
      return DTOLote(
        id: data['id'],
        dataEntrada: DateTime.parse(data['dataEntrada']),
        quantidadeAves: data['quantidadeAves'],
        pesoMedio: data['pesoMedio'],
        qtdRacaoInicial: data['qtdRacaoInicial'],
      );
    }
    return null;
  }

  @override
  Future<List<DTOLote>> buscarTodos() async {
    final response = await supabase.from('lote').select();

    if (response.error != null) {
      throw Exception('Erro ao buscar os lotes: ${response.error!.message}');
    }

    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((lote) {
      final map = lote as Map<String, dynamic>;
      return DTOLote(
        id: map['id'],
        dataEntrada: DateTime.parse(map['dataEntrada']),
        quantidadeAves: map['quantidadeAves'],
        pesoMedio: map['pesoMedio'],
        qtdRacaoInicial: map['qtdRacaoInicial'],
      );
    }).toList();
  }

  @override
  Future<void> deletar(dynamic id) async {
    final response = await supabase.from('lote').delete().eq('id', id);

    if (response.error != null) {
      throw Exception('Erro ao deletar o lote: ${response.error!.message}');
    }
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
