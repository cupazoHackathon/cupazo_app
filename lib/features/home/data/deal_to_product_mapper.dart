import '../domain/models/product.dart';
import '../../../data/models/deal_model.dart';

/// Mapper to convert DealModel to Product for UI compatibility
class DealToProductMapper {
  /// Convert a DealModel to a Product
  static Product toProduct(DealModel deal) {
    // Use regular_price from DB if available, otherwise estimate it
    final double regularPrice = deal.regularPrice > 0 
        ? deal.regularPrice 
        : deal.price * 1.2; // Fallback estimate if regular_price is missing
        
    // The deal price is the group offer price
    final double offerPrice = deal.price;

    final discountPercentage =
        ((regularPrice - offerPrice) / regularPrice * 100).round();

    // Calculate group prices based on max group size
    // If maxGroupSize >= 6, use that for groupPrice6Plus
    final groupPrice3 = offerPrice; // This is the main offer price
    final groupPrice6Plus = deal.maxGroupSize >= 6
        ? deal.price * 0.90 // Additional discount for larger groups if logic exists
        : deal.price;

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
      originalPrice: regularPrice, // Precio tachado
      currentPrice: regularPrice,  // Precio individual (venta normal)
      discountPercentage: discountPercentage,
      imageUrl: deal.imageUrl.isNotEmpty
          ? deal.imageUrl
          : 'https://via.placeholder.com/400?text=${Uri.encodeComponent(deal.title)}',
      groupPrice3: groupPrice3,    // Precio oferta grupo
      groupPrice6Plus: groupPrice6Plus,
      interestedCount: 0, // Will be updated from deal_interests if needed
      category: deal.category,
      isFavorite: false,
      activeGroupAvatar: deal.activeGroupAvatar,
    );
  }

  /// Convert a list of DealModel to a list of Product
  static List<Product> toProductList(List<DealModel> deals) {
    return deals.map((deal) => toProduct(deal)).toList();
  }
}
