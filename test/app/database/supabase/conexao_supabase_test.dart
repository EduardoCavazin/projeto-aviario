import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:projeto_avirario/app/database/supabase/conexao_supabase.dart';

void main() {
  test('DatabaseConnection deve instanciar corretamente o SupabaseClient', () {
    final dbConnection = DatabaseConnection();
    expect(dbConnection.client, isA<SupabaseClient>());
  });

  test('DatabaseConnection deve ser uma instância singleton', () {
    final dbConnection1 = DatabaseConnection();
    final dbConnection2 = DatabaseConnection();
    expect(dbConnection1, equals(dbConnection2)); 
  });
}
