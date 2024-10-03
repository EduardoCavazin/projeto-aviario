import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:projeto_avirario/app/database/supabase/dao_propriedade_supabase.dart';
import 'package:projeto_avirario/app/domain/dto/dto_propriedade.dart';
import 'package:supabase/supabase.dart';

import '../../../mock_suplementaries.mocks.dart';

class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder {}

void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockPostgrestFilterBuilder mockQueryBuilder;
  late PropriedadeSupabaseDAO dao;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockQueryBuilder = MockPostgrestFilterBuilder();
    dao = PropriedadeSupabaseDAO(client: mockSupabaseClient); 
  });

  group('PropriedadeSupabaseDAO', () {
    test('deve salvar uma propriedade com sucesso', () async {
      // Cria uma resposta simulada para o Supabase
      final mockResponse = {
        'id': 1,
        'nome': 'Propriedade Teste',
        'localizacao': 'Local Teste',
        'qtdAviario': 5,
      };

      // Simula a resposta do método insert() e select()
      when(mockSupabaseClient
              .from('propriedade')
              .insert(any))
          .thenReturn(mockQueryBuilder);

      when(mockQueryBuilder.select())
          .thenAnswer((_) async => PostgrestResponse(data: [mockResponse], error: null));

      final propriedade = DTOPropriedade(
        nome: 'Propriedade Teste',
        localizacao: 'Local Teste',
        qtdAviario: 5,
      );

      final result = await dao.salvar(propriedade);

      expect(result.id, 1);
      expect(result.nome, 'Propriedade Teste');
      expect(result.localizacao, 'Local Teste');
      expect(result.qtdAviario, 5);
    });
  });
}
