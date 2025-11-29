import '../domain/models/product.dart';
import '../../../data/models/deal_model.dart';

/// Mapper to convert DealModel to Product for UI compatibility
class DealToProductMapper {
  /// Convert a DealModel to a Product
  static Product toProduct(DealModel deal) {
    // Calculate discount percentage (assuming original price is 20% higher)
    final originalPrice = deal.price * 1.2;
    final discountPercentage =
        ((originalPrice - deal.price) / originalPrice * 100).round();

    // Calculate group prices based on max group size
    // If maxGroupSize >= 6, use that for groupPrice6Plus
    // Otherwise, calculate a reasonable group price
    final groupPrice3 = deal.price * 0.85; // 15% discount for 3 people
    final groupPrice6Plus = deal.maxGroupSize >= 6
        ? deal.price * 0.75 // 25% discount for 6+ people
        : deal.price * 0.80; // 20% discount for smaller groups

    // Extract brand from title if it contains a dash or colon
    // Otherwise use a default or extract from title
    String brand = 'Cupazo';
    String name = deal.title;

    // Try to extract brand from title (e.g., "Nike - Air Max" or "Zara: Blusa")
    if (deal.title.contains(' - ')) {
      final parts = deal.title.split(' - ');
      if (parts.length >= 2) {
        brand = parts[0].trim();
        name = parts.sublist(1).join(' - ').trim();
      }
    } else if (deal.title.contains(': ')) {
      final parts = deal.title.split(': ');
      if (parts.length >= 2) {
        brand = parts[0].trim();
        name = parts.sublist(1).join(': ').trim();
      }
    }

    return Product(
      id: deal.id,
      brand: brand,
      name: name,
      originalPrice: originalPrice,
      currentPrice: deal.price,
      discountPercentage: discountPercentage,
      imageUrl: deal.imageUrl.isNotEmpty
          ? deal.imageUrl
          : 'https://via.placeholder.com/400?text=${Uri.encodeComponent(deal.title)}',
      groupPrice3: groupPrice3,
      groupPrice6Plus: groupPrice6Plus,
      interestedCount: 0, // Will be updated from deal_interests if needed
      category: deal.category,
      isFavorite: false,
    );
  }

  /// Convert a list of DealModel to a list of Product
  static List<Product> toProductList(List<DealModel> deals) {
    return deals.map((deal) => toProduct(deal)).toList();
  }
}

