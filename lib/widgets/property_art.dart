import 'package:flutter/material.dart';
import '../data/property.dart';

List<Color> paletteForType(String type) {
  switch (type) {
    case 'Maison':
      return const [Color(0xFF0B5FA5), Color(0xFF1B9AD6)];
    case 'Appartement':
      return const [Color(0xFF3B3FAE), Color(0xFF6C7BF0)];
    case 'Chambre / Studio':
      return const [Color(0xFF0E8F7E), Color(0xFF3CCBA5)];
    case 'Parcelle':
      return const [Color(0xFF3E8E41), Color(0xFF9CCB5A)];
    case 'Local commercial':
      return const [Color(0xFFC1581B), Color(0xFFF2A15A)];
  }
  return const [Color(0xFF0B5FA5), Color(0xFF1B9AD6)];
}

/// Visuel d'annonce (en attendant de vraies photos) : dégradé + formes + icône.
class PropertyArt extends StatelessWidget {
  const PropertyArt({super.key, required this.type, this.height, this.child});

  final String type;
  final double? height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colors = paletteForType(type);
    final art = LayoutBuilder(
      builder: (context, c) {
        final h = c.hasBoundedHeight ? c.maxHeight : (height ?? 150);
        final w = c.hasBoundedWidth ? c.maxWidth : h * 1.6;
        final side = h < w ? h : w;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(right: -side * 0.18, top: -side * 0.3, child: _Dot(side * 0.95, 0.10)),
              Positioned(left: -side * 0.22, bottom: -side * 0.42, child: _Dot(side * 0.9, 0.08)),
              Positioned(right: w * 0.18, bottom: h * 0.12, child: _Dot(side * 0.16, 0.14)),
              Center(
                child: Container(
                  width: side * 0.46,
                  height: side * 0.46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.18),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
                  ),
                  child: Icon(iconForType(type), size: side * 0.24, color: Colors.white),
                ),
              ),
              if (child != null) child!,
            ],
          ),
        );
      },
    );
    return height == null ? art : SizedBox(height: height, width: double.infinity, child: art);
  }
}

class _Dot extends StatelessWidget {
  const _Dot(this.size, this.alpha);
  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: alpha),
      ),
    );
  }
}
