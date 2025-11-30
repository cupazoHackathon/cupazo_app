import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_recommendation.dart';

class RecommendationService {
  final SupabaseClient _client;

  // ⚠️ Usuario de prueba que SÍ tiene recomendaciones
  static const debugUserId = '00016086-5252-4947-a2e2-f5a208bb6d5c';

  RecommendationService([SupabaseClient? client])
    : _client = client ?? Supabase.instance.client;

  Future<List<UserRecommendation>> getUserRecommendations() async {
    // Más adelante: usar auth.currentUser.id
    // final user = _client.auth.currentUser;

    final response = await _client.functions.invoke(
      'user_recommendations',
      body: {'user_id': debugUserId},
    );

    final data = response.data as Map<String, dynamic>;
    final list = data['recommendations'] as List<dynamic>? ?? [];

    var recommendations = list
        .map((e) => UserRecommendation.fromJson(e))
        .toList();

    // Filtrar si el usuario es comprador (solo ver otros compradores)
    try {
      final userResponse = await _client
          .from('users')
          .select('role')
          .eq('id', debugUserId)
          .maybeSingle();

      if (userResponse != null) {
        final role = userResponse['role'] as String?;
        if (role == 'buyer') {
          recommendations = recommendations
              .where((r) => r.candidateRole == 'buyer')
              .toList();
        }
      }
    } catch (e) {
      // En caso de error al obtener el rol, retornamos la lista sin filtrar adicionalmente
      print('Error checking user role: $e');
    }

    return recommendations;
  }
}
