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
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        decoration: BoxDecoration(color: AppColors.background),
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
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepBlack,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryYellow.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$productCount',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepBlack,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'productos disponibles',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      color: AppColors.inkSoft,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
