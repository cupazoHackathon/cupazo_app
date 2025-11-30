import 'package:flutter/material.dart';

/// Wordmark para Cupazo App
class CupazoWordmark extends StatelessWidget {
  final double fontSize;
  final bool showLogo;
  final EdgeInsetsGeometry? padding;
  final double logoSize;

  const CupazoWordmark({
    super.key,
    this.fontSize = 30,
    this.logoSize = 100,
    this.showLogo = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Estilo para la marca
    final textStyle = TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
      height: 1.1,
      color: Colors.white,
    );

    // Logo real de Cupazo
    final logo = Image.asset(
      'assets/cupazo.png',
      width: logoSize,
      height: logoSize,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback en caso de que la imagen no se encuentre
        return Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.local_fire_department,
            color: Colors.white,
            size: logoSize * 0.6,
          ),
        );
      },
    );

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showLogo) ...[logo, const SizedBox(height: 8)],
          Text('Cupazo', style: textStyle),
        ],
      ),
    );
  }
}
