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
  Future<List<DealModel>> getDealsByCategory(String category) async {
    try {
      final response = await _supabase
          .from('deals')
          .select()
          .eq('category', category)
          .eq('active', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => DealModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
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

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
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

