import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';

/// Barra de filtros con botón de filtros y dropdown de ordenamiento
class FilterBar extends StatelessWidget {
  final VoidCallback? onFiltersPressed;
  final String? selectedSort;
  final ValueChanged<String>? onSortChanged;

  const FilterBar({
    super.key,
    this.onFiltersPressed,
    this.selectedSort,
    this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(color: AppColors.background),
      child: Row(
        children: [
          // Filters Button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onFiltersPressed,
              icon: Icon(Icons.tune, color: AppColors.primaryYellow),
              label: Text(
                'Filtros',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.primaryYellow.withOpacity(0.1),
                side: BorderSide(color: AppColors.primaryYellow, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Sort Dropdown
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryYellow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryYellow, width: 1.5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSort ?? 'relevante',
                  isExpanded: true,
                  icon: Icon(Icons.keyboard_arrow_down, color: AppColors.ink),
                  items: const [
                    DropdownMenuItem(
                      value: 'relevante',
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Más Relevante',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'precio_asc',
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Precio: Menor a Mayor',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'precio_desc',
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Precio: Mayor a Menor',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null && onSortChanged != null) {
                      onSortChanged!(value);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
