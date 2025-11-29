import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';

/// Barra de búsqueda reutilizable para la parte superior
class AppSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onBackPressed;
  final VoidCallback? onCartPressed;
  final VoidCallback? onProfilePressed;
  final ValueChanged<String>? onSearchChanged;

  const AppSearchBar({
    super.key,
    this.hintText = 'Buscar en esta categoría',
    this.onBackPressed,
    this.onCartPressed,
    this.onProfilePressed,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.deepBlack,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Back Button
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryYellow,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.deepBlack),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: 8),

          // Search Bar - limitado en ancho para que no pase la franja negra
          Flexible(
            flex: 3,
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Cart Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryYellow,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.deepBlack,
              ),
              onPressed: onCartPressed,
            ),
          ),
          const SizedBox(width: 8),

          // Profile Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryYellow,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.person_outline, color: AppColors.deepBlack),
              onPressed: onProfilePressed,
            ),
          ),
        ],
      ),
    );
  }
}
