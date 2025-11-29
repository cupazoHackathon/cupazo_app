import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';

/// Header de categoría con título y contador de productos
class CategoryHeader extends StatelessWidget {
  final String categoryName;
  final int productCount;

  const CategoryHeader({
    super.key,
    required this.categoryName,
    required this.productCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1), // Light cream background
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              categoryName,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 32, // Aumentado de 24 a 32 para que se vea más grande
                fontWeight: FontWeight.bold,
                color: AppColors.deepBlack,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '$productCount productos disponibles',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                color: AppColors.inkSoft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
