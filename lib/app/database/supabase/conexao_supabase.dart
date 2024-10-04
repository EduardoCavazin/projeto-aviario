import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseConnection {
  final SupabaseClient supabase;

  DatabaseConnection._internal()
      : supabase = SupabaseClient(
          'https://yqwfskkndydcaheouhlu.supabase.co',
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlxd2Zza2tuZHlkY2FoZW91aGx1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc5NzI1OTksImV4cCI6MjA0MzU0ODU5OX0.TkvBUaLNcKxOM8hhLHUzDsc_0moC0M5kxyP9UKmQcg0',
        );

  static final DatabaseConnection _instance = DatabaseConnection._internal();

  factory DatabaseConnection() {
    return _instance;
  }

  SupabaseClient get client => supabase;
}
