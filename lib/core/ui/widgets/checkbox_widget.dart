import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// Checkbox basado en design.json
class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final bool tristate;

  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.tristate = false,
  });

  @override
  Widget build(BuildContext context) {
    final widget = Checkbox(
      value: value,
      onChanged: onChanged,
      tristate: tristate,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      // Checkbox border_width: 2
      side: const BorderSide(color: AppColors.line, width: 2),
      checkColor: AppColors.accentPrimary,
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.accentPrimary;
        }
        return Colors.transparent;
      }),
    );

    if (label != null) {
      return Row(
        children: [
          SizedBox(
            // Checkbox size: 20
            width: 20,
            height: 20,
            child: widget,
          ),
          // Spacing from label: 12
          const SizedBox(width: 12),
          // Checkbox label - 14px, regular
          Text(
            label!,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              letterSpacing: 0,
              height: 1.4,
              color: AppColors.ink,
            ),
          ),
        ],
      );
    }

    return widget;
  }
}


