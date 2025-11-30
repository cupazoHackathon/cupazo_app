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

    final discountPercentage = _calculateDiscount(
      deal.regularPrice,
      deal.price,
    );

    // Calculate group prices based on max group size
    // If maxGroupSize >= 6, use that for groupPrice6Plus
    final groupPrice3 = offerPrice; // This is the main offer price
    final groupPrice6Plus = deal.maxGroupSize >= 6
        ? deal.price *
              0.90 // Additional discount for larger groups if logic exists
        : deal.price;

    // Extract brand and name from title
    final brand = _extractBrand(deal.title);
    final name = _extractName(deal.title);

    return Product(
      id: deal.id,
      brand: brand,
      name: name,
      originalPrice: regularPrice, // Precio tachado
      currentPrice: regularPrice, // Precio individual (venta normal)
      discountPercentage: discountPercentage,
      imageUrl: deal.imageUrl, // Ya filtrado, siempre tiene imagen
      groupPrice3: groupPrice3, // Precio oferta grupo
      groupPrice6Plus: groupPrice6Plus,
      interestedCount: 0, // Will be updated from deal_interests if needed
      category: deal.category,
      isFavorite: false,
      activeGroupAvatar: deal.activeGroupAvatar,
    );
  }

  /// Convert a list of DealModel to a list of Product
  /// Solo convierte deals que tienen imageUrl válido (no null y no vacío)
  static List<Product> toProductList(List<DealModel> deals) {
    print(
      '🔄 [DealToProductMapper] Iniciando conversión de ${deals.length} deals',
    );

    // Convertir todos los deals (ya vienen filtrados de Supabase, solo con image_url no null)
    final products = deals.map((deal) => toProduct(deal)).toList();

    print('✅ [DealToProductMapper] Productos convertidos: ${products.length}');
    return products;
  }

  /// Extract brand from title
  static String _extractBrand(String title) {
    if (title.contains(' - ')) {
      final parts = title.split(' - ');
      if (parts.length >= 2) {
        return parts[0].trim();
      }
    } else if (title.contains(': ')) {
      final parts = title.split(': ');
      if (parts.length >= 2) {
        return parts[0].trim();
      }
    }
    return 'Cupazo';
  }

  /// Extract name from title
  static String _extractName(String title) {
    if (title.contains(' - ')) {
      final parts = title.split(' - ');
      if (parts.length >= 2) {
        return parts.sublist(1).join(' - ').trim();
      }
    } else if (title.contains(': ')) {
      final parts = title.split(': ');
      if (parts.length >= 2) {
        return parts.sublist(1).join(': ').trim();
      }
    }
    return title;
  }

  /// Calculate discount percentage
  static int _calculateDiscount(double regularPrice, double offerPrice) {
    if (regularPrice <= 0) {
      final estimatedRegular = offerPrice * 1.2;
      return ((estimatedRegular - offerPrice) / estimatedRegular * 100).round();
    }
    return ((regularPrice - offerPrice) / regularPrice * 100).round();
  }
}
