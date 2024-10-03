import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseConnection {
  final SupabaseClient supabase;

  DatabaseConnection._internal()
      : supabase = SupabaseClient(
          'https://yqwfskkndydcaheouhlu.supabase.co',
          'your-anon-key',
        );

  static final DatabaseConnection _instance = DatabaseConnection._internal();

  factory DatabaseConnection() {
    return _instance;
  }

  SupabaseClient get client => supabase;
}
