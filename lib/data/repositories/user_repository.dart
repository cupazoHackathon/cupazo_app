import '../models/user_model.dart';
import '../../services/supabase_service.dart';

/// Repository for user-related database operations
class UserRepository {
  final _supabase = SupabaseService.client;

  /// Get a user by their ID
  Future<UserModel?> getUserById(String id) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Error fetching user by id: $e');
    }
  }

  /// Get all users in a specific city
  Future<List<UserModel>> getUsersByCity(String city) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('city', city);

      return (response as List)
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching users by city: $e');
    }
  }
}

// Example usage:
// final userRepo = UserRepository();
// final user = await userRepo.getUserById('user-uuid');
// final cityUsers = await userRepo.getUsersByCity('Madrid');

