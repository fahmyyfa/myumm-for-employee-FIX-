import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AppSupabaseClient {
  AppSupabaseClient._();

  static sb.SupabaseClient get instance => sb.Supabase.instance.client;

  static sb.GoTrueClient get auth => instance.auth;

  static sb.SupabaseQueryBuilder table(String tableName) => instance.from(tableName);

  static sb.SupabaseStorageClient get storage => instance.storage;
}
