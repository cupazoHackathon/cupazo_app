import 'dart:math' as math;

import '../models/deal_model.dart';
import '../../services/supabase_service.dart';

/// Repository for deal-related database operations
class DealRepository {
  final _supabase = SupabaseService.client;

  /// Get a deal by its ID
  Future<DealModel?> getDealById(String id) async {
    try {
      final response = await _supabase
          .from('deals')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return DealModel.fromJson(response);
    } catch (e) {
      throw Exception('Error fetching deal by id: $e');
    }
  }

  /// Get all deals in a specific category
  /// Solo retorna deals que tienen image_url no null
  Future<List<DealModel>> getDealsByCategory(String category) async {
    try {
      print('📡 [DealRepository] Consultando deals con categoría: "$category"');
      print(
        '📡 [DealRepository] Filtros: category="$category", active=true, image_url IS NOT NULL',
      );

      // Consulta que excluye solo los deals con image_url null
      print('📡 [DealRepository] Ejecutando consulta...');
      final response = await _supabase
          .from('deals')
          .select('*')
          .eq('category', category)
          .eq('active', true)
          .not(
            'image_url',
            'is',
            null,
          ) // Excluir solo los que tienen image_url null
          .order('created_at', ascending: false);

      print('📡 [DealRepository] Respuesta recibida de Supabase');
      print('📡 [DealRepository] Tipo de respuesta: ${response.runtimeType}');

      final dealsList = (response as List);
      print(
        '📡 [DealRepository] Total de registros en respuesta: ${dealsList.length}',
      );

      if (dealsList.isNotEmpty) {
        print('📡 [DealRepository] Primer registro: ${dealsList.first}');
      }

      final deals = dealsList.map((json) {
        try {
          return DealModel.fromJson(json as Map<String, dynamic>);
        } catch (e) {
          print('⚠️ [DealRepository] Error al parsear deal: $e');
          print('⚠️ [DealRepository] JSON problemático: $json');
          rethrow;
        }
      }).toList();

      print('✅ [DealRepository] Deals parseados exitosamente: ${deals.length}');
      return deals;
    } catch (e, stackTrace) {
      print('❌ [DealRepository] ERROR en getDealsByCategory: $e');
      print('❌ [DealRepository] Stack trace: $stackTrace');
      throw Exception('Error fetching deals by category: $e');
    }
  }

  /// Get all active deals
  Future<List<DealModel>> getActiveDeals() async {
    try {
      final response = await _supabase
          .from('deals')
          .select()
          .eq('active', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => DealModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching active deals: $e');
    }
  }

  /// Get active deals near a location (optional radius in km)
  Future<List<DealModel>> getActiveDealsNear(
    double lat,
    double lng, {
    double? radiusKm,
  }) async {
    try {
      // Using PostGIS distance calculation if available
      // Otherwise, fetch all active deals and filter in memory
      var query = _supabase
          .from('deals')
          .select()
          .eq('active', true)
          .order('created_at', ascending: false);

      final response = await query;

      final deals = (response as List)
          .map((json) => DealModel.fromJson(json as Map<String, dynamic>))
          .toList();

      // If radius is specified, filter by distance
      if (radiusKm != null) {
        return deals.where((deal) {
          final distance = _calculateDistance(
            lat,
            lng,
            deal.locationLat,
            deal.locationLng,
          );
          return distance <= radiusKm;
        }).toList();
      }

      return deals;
    } catch (e) {
      throw Exception('Error fetching deals near location: $e');
    }
  }

  /// Calculate distance between two coordinates using Haversine formula
  /// Returns distance in kilometers
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // Earth radius in kilometers

    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.asin(math.sqrt(a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * (3.14159265359 / 180);
}

// Example usage:
// final dealRepo = DealRepository();
// final deal = await dealRepo.getDealById('deal-uuid');
// final categoryDeals = await dealRepo.getDealsByCategory('Ropa');
// final activeDeals = await dealRepo.getActiveDeals();
// final nearbyDeals = await dealRepo.getActiveDealsNear(40.4168, -3.7038, radiusKm: 10);
