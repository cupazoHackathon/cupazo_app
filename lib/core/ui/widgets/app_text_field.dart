import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/radii.dart';
import '../theme/spacing.dart';

/// Text Field basado en design.json
class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final IconData? leadingIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.leadingIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
    this.onChanged,
    this.onTap,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isFocused = false;
  String? _validationError;

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null || _validationError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: AppTypography.bodySmall),
          const SizedBox(height: AppSpacing.xs),
        ],
        Container(
          height: widget.maxLines == 1 ? 52 : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(
              color: hasError
                  ? AppColors.accentDanger
                  : _isFocused
                  ? AppColors.accentPrimary
                  : AppColors.line,
              width: 1,
            ),
            boxShadow: _isFocused && !hasError
                ? [
                    BoxShadow(
                      color: AppColors.accentPrimary.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            onChanged: (value) {
              if (widget.validator != null) {
                setState(() {
                  _validationError = widget.validator!(value);
                });
              }
              widget.onChanged?.call(value);
            },
            enabled: widget.enabled,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            validator: widget.validator,
            style: AppTypography.body,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTypography.body.copyWith(color: AppColors.inkSoft),
              prefixIcon: widget.leadingIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Icon(
                        widget.leadingIcon,
                        color: AppColors.inkMuted,
                        size: 22,
                      ),
                    )
                  : null,
              prefixIconConstraints: widget.leadingIcon != null
                  ? const BoxConstraints(
                      minWidth: 42,
                      minHeight: 52,
                    )
                  : null,
              suffixIcon: widget.suffixIcon,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: widget.leadingIcon != null ? 0 : AppSpacing.md,
                vertical: widget.maxLines == 1 ? 16 : AppSpacing.md,
              ),
              counterText: '',
            ),
            onTap: () {
              setState(() => _isFocused = true);
              widget.onTap?.call();
            },
            onFieldSubmitted: (_) => setState(() => _isFocused = false),
            onEditingComplete: () => setState(() => _isFocused = false),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.errorText ?? _validationError ?? '',
            style: AppTypography.caption.copyWith(
              color: AppColors.accentDanger,
            ),
          ),
        ],
      ],
    );
  }
}


