/// Modelo de producto
class Product {
  final String id;
  final String brand;
  final String name;
  final double originalPrice;
  final double currentPrice;
  final int discountPercentage;
  final String imageUrl;
  final double groupPrice3; // Precio para 3 personas
  final double groupPrice6Plus; // Precio por mayor (6+)
  final int interestedCount;
  final String category;
  final bool isFavorite;
  final String? activeGroupAvatar;

  Product({
    required this.id,
    required this.brand,
    required this.name,
    required this.originalPrice,
    required this.currentPrice,
    required this.discountPercentage,
    required this.imageUrl,
    required this.groupPrice3,
    required this.groupPrice6Plus,
    required this.interestedCount,
    required this.category,
    this.isFavorite = false,
    this.activeGroupAvatar,
  });
}

