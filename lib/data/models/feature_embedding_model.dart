/// Feature embedding model representing the `feature_embeddings` table
class FeatureEmbeddingModel {
  final String id;
  final String entityType;
  final String entityId;
  final List<double> embedding;
  final String source;
  final DateTime updatedAt;

  FeatureEmbeddingModel({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.embedding,
    required this.source,
    required this.updatedAt,
  });

  factory FeatureEmbeddingModel.fromJson(Map<String, dynamic> json) {
    // Handle vector type - convert from List<dynamic> or List<num> to List<double>
    final embeddingData = json['embedding'];
    List<double> embeddingList;
    if (embeddingData is List) {
      embeddingList = embeddingData
          .map((e) => (e as num).toDouble())
          .toList()
          .cast<double>();
    } else {
      embeddingList = [];
    }

    return FeatureEmbeddingModel(
      id: json['id'] as String,
      entityType: json['entity_type'] as String,
      entityId: json['entity_id'] as String,
      embedding: embeddingList,
      source: json['source'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entity_type': entityType,
      'entity_id': entityId,
      'embedding': embedding,
      'source': source,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

