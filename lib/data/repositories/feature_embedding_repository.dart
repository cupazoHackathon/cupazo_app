import '../models/feature_embedding_model.dart';
import '../../services/supabase_service.dart';

/// Repository for feature embedding-related database operations
class FeatureEmbeddingRepository {
  final _supabase = SupabaseService.client;

  /// Get embedding for a specific entity
  Future<FeatureEmbeddingModel?> getEmbeddingForEntity(
    String entityType,
    String entityId,
  ) async {
    try {
      final response = await _supabase
          .from('feature_embeddings')
          .select()
          .eq('entity_type', entityType)
          .eq('entity_id', entityId)
          .maybeSingle();

      if (response == null) return null;
      return FeatureEmbeddingModel.fromJson(response);
    } catch (e) {
      throw Exception('Error fetching embedding for entity: $e');
    }
  }

  /// Upsert (insert or update) an embedding
  Future<void> upsertEmbedding(FeatureEmbeddingModel embedding) async {
    try {
      await _supabase.from('feature_embeddings').upsert(
            embedding.toJson(),
            onConflict: 'id',
          );
    } catch (e) {
      throw Exception('Error upserting embedding: $e');
    }
  }
}

// Example usage:
// final embeddingRepo = FeatureEmbeddingRepository();
// final embedding = await embeddingRepo.getEmbeddingForEntity('deal', 'deal-uuid');
// await embeddingRepo.upsertEmbedding(embeddingModel);

