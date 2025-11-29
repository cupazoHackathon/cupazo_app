/// Match recommendation model representing the `match_recommendations` table
class MatchRecommendationModel {
  final String id;
  final String userId;
  final String candidateId;
  final double distanceKm;
  final double similarity;
  final double reliabilityScore;
  final String role;
  final int rank;
  final DateTime createdAt;

  MatchRecommendationModel({
    required this.id,
    required this.userId,
    required this.candidateId,
    required this.distanceKm,
    required this.similarity,
    required this.reliabilityScore,
    required this.role,
    required this.rank,
    required this.createdAt,
  });

  factory MatchRecommendationModel.fromJson(Map<String, dynamic> json) {
    return MatchRecommendationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      candidateId: json['candidate_id'] as String,
      distanceKm: (json['distance_km'] as num).toDouble(),
      similarity: (json['similarity'] as num).toDouble(),
      reliabilityScore: (json['reliability_score'] as num).toDouble(),
      role: json['role'] as String,
      rank: json['rank'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'candidate_id': candidateId,
      'distance_km': distanceKm,
      'similarity': similarity,
      'reliability_score': reliabilityScore,
      'role': role,
      'rank': rank,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

