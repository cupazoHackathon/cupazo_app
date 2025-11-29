import 'package:supabase_flutter/supabase_flutter.dart';

/// Single entry point for all Supabase database operations
/// All repositories should use this service to access Supabase client
class SupabaseService {
  /// Static Supabase client instance
  static final SupabaseClient client = Supabase.instance.client;
}

