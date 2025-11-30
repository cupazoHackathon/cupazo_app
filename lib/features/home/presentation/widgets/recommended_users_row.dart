import 'package:flutter/material.dart';
import '../../../../data/models/user_recommendation.dart';
import '../../../../data/services/recommendation_service.dart';

class RecommendedUsersRow extends StatefulWidget {
  final bool? showBuyersOnly;

  const RecommendedUsersRow({
    super.key,
    this.showBuyersOnly,
  });

  @override
  State<RecommendedUsersRow> createState() => _RecommendedUsersRowState();
}

class _RecommendedUsersRowState extends State<RecommendedUsersRow> {
  late Future<List<UserRecommendation>> _recommendationsFuture;
  final RecommendationService _recommendationService = RecommendationService();

  @override
  void initState() {
    super.initState();
    _recommendationsFuture = _recommendationService.getUserRecommendations();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Personas recomendadas para ti',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SizedBox(
          height: 140, // Adjust height as needed
          child: FutureBuilder<List<UserRecommendation>>(
            future: _recommendationsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error al cargar recomendaciones',
                    style: TextStyle(color: Colors.red[300]),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No hay recomendaciones aún'),
                );
              }

              var recommendations = snapshot.data!;

              if (widget.showBuyersOnly != null) {
                final roleFilter = widget.showBuyersOnly! ? 'buyer' : 'seller';
                recommendations = recommendations
                    .where((r) => r.candidateRole == roleFilter)
                    .toList();
              }

              if (recommendations.isEmpty) {
                 return const Center(
                  child: Text('No hay recomendaciones con este filtro'),
                );
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: recommendations.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final user = recommendations[index];
                  return _buildUserItem(context, user);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserItem(BuildContext context, UserRecommendation user) {
    final initials = user.candidateName.isNotEmpty
        ? user.candidateName.substring(0, 2).toUpperCase()
        : '??';
    final roleLabel = user.candidateRole == 'buyer' ? 'Comprador' : 'Vendedor';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Text(
            initials,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            user.candidateName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          roleLabel,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        // Optional match score or city
        Text(
          '${(user.similarity * 100).toInt()}% match',
           style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }
}

