/// Deal model representing the `deals` table
class DealModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String type;
  final int maxGroupSize;
  final double price;
  final double regularPrice;
  final String category;
  final double locationLat;
  final double locationLng;
  final bool active;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String imageUrl;
  final String? activeGroupAvatar;

  DealModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.type,
    required this.maxGroupSize,
    required this.price,
    required this.regularPrice,
    required this.category,
    required this.locationLat,
    required this.locationLng,
    required this.active,
    required this.createdAt,
    required this.expiresAt,
    required this.imageUrl,
    this.activeGroupAvatar,
  });

  factory DealModel.fromJson(Map<String, dynamic> json) {
    // Extraer avatar del grupo activo si existe en la respuesta unida
    String? avatarUrl;
    if (json['match_groups'] != null && json['match_groups'] is List) {
      final groups = json['match_groups'] as List;
      // Buscar un grupo activo (open)
      final activeGroup = groups.firstWhere(
        (g) => g['status'] == 'open',
        orElse: () => null,
      );

      if (activeGroup != null && activeGroup['match_group_members'] != null) {
        final members = activeGroup['match_group_members'] as List;
        if (members.isNotEmpty) {
          // Usamos una imagen de perfil por defecto ya que no podemos hacer join con users
          // por restricciones de la base de datos (tabla users no existe o no tiene permisos)
          avatarUrl = 'https://ui-avatars.com/api/?name=U&background=random';
        }
      }
    }

    return DealModel(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? '',
      title: json['title'] as String? ?? 'Sin título',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? '',
      maxGroupSize: json['max_group_size'] as int? ?? 2,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      regularPrice: (json['regular_price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? '',
      locationLat: (json['location_lat'] as num?)?.toDouble() ?? 0.0,
      locationLng: (json['location_lng'] as num?)?.toDouble() ?? 0.0,
      active: json['active'] as bool? ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : DateTime.now(),
      // Si expires_at es null, usamos una fecha futura lejana o la misma de creación
      expiresAt: json['expires_at'] != null 
          ? DateTime.parse(json['expires_at'] as String) 
          : DateTime.now().add(const Duration(days: 30)),
      imageUrl: json['image_url'] as String? ?? '',
      activeGroupAvatar: avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'type': type,
      'max_group_size': maxGroupSize,
      'price': price,
      'regular_price': regularPrice,
      'category': category,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'active': active,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'image_url': imageUrl,
    };
  }
}
