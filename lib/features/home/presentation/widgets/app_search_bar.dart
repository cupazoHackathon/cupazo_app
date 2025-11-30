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
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: onBackPressed ?? () => Navigator.of(context).pop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.arrow_back, color: AppColors.deepBlack),
            ),
          ),
          const SizedBox(width: 12),

          // Search Bar
          Flexible(
            flex: 3,
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
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
                    color: AppColors.inkLighter,
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColors.inkLight),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 11,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Cart Icon
          _buildActionButton(
            icon: Icons.shopping_cart_outlined,
            onTap: onCartPressed,
          ),
          const SizedBox(width: 8),

          // Profile Icon
          _buildActionButton(
            icon: Icons.person_outline,
            onTap: onProfilePressed,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.deepBlack),
      ),
    );
  }
}
