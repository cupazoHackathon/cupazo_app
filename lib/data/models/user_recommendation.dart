class UserRecommendation {
  final String candidateUserId;
  final String candidateName;
  final String candidateRole;
  final double distanceKm;
  final double similarity;
  final double reliabilityScore;
  final int rank;
  final String city;

  UserRecommendation({
    required this.candidateUserId,
    required this.candidateName,
    required this.candidateRole,
    required this.distanceKm,
    required this.similarity,
    required this.reliabilityScore,
    required this.rank,
    required this.city,
  });

  factory UserRecommendation.fromJson(Map<String, dynamic> json) {
    return UserRecommendation(
      candidateUserId: json['candidate_user_id'] as String? ?? '',
      candidateName: json['candidate_name'] as String? ?? 'Unknown',
      candidateRole: json['candidate_role'] as String? ?? '',
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0.0,
      similarity: (json['similarity'] as num?)?.toDouble() ?? 0.0,
      reliabilityScore: (json['reliability_score'] as num?)?.toDouble() ?? 0.0,
      rank: json['rank'] as int? ?? 0,
      city: json['city'] as String? ?? 'Unknown',
    );
  }
}

