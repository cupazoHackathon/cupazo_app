import 'package:flutter/material.dart';

/// Wordmark para Cupazo App
class CupazoWordmark extends StatelessWidget {
  final double brandFontSize;
  final double productFontSize;
  final bool showLogo;
  final EdgeInsetsGeometry? padding;
  final double logoSize;

  const CupazoWordmark({
    super.key,
    this.brandFontSize = 13,
    this.productFontSize = 30,
    this.logoSize = 48,
    this.showLogo = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Estilo para la marca - más sutil y elegante
    final brandStyle = TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      fontSize: brandFontSize,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.4,
      height: 1.2,
      color: Colors.white.withOpacity(0.92),
    );

    // Estilo para el producto - más prominente y legible
    final productStyle = TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      fontSize: productFontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.3,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showLogo) ...[logo, const SizedBox(width: 16)],
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Cupazo', style: brandStyle),
                const SizedBox(height: 2),
                Text('App', style: productStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


