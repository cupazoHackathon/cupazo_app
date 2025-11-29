import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';

/// Card verde de ahorro en grupo
class GroupDealCard extends StatelessWidget {
  final double groupPrice3;
  final double groupPrice6Plus;

  const GroupDealCard({
    super.key,
    required this.groupPrice3,
    required this.groupPrice6Plus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.statusSuccess.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.statusSuccess,
          width: 1.2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.group,
                size: 12,
                color: AppColors.statusSuccess,
              ),
              const SizedBox(width: 3),
              Flexible(
                child: Text(
                  '¡Ahorra en Grupo!',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.statusSuccess,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            '3 personas: S/ ${groupPrice3.toStringAsFixed(2)} c/u',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 9,
              color: AppColors.ink,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          Text(
            'Por Mayor (6+): S/ ${groupPrice6Plus.toStringAsFixed(2)} c/u',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 9,
              color: AppColors.ink,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

