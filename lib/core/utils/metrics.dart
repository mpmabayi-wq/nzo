import 'package:flutter/material.dart';

/// Regroupe les informations de l'appareil (écran, taille du texte, mode
/// d'animation...) pour que toute l'interface s'adapte de façon uniforme.
///
/// - [s]    : dimensions (marges, rayons...) proportionnelles à la largeur de l'écran
/// - [icon] : icônes, qui suivent le réglage « taille du texte » de l'appareil
/// - [fit]  : hauteurs contenant du texte (suivent écran + taille du texte)
class Metrics {
  Metrics._(this.mq);

  final MediaQueryData mq;

  factory Metrics.of(BuildContext context) => Metrics._(MediaQuery.of(context));

  double get width => mq.size.width;
  double get height => mq.size.height;
  EdgeInsets get safe => mq.padding;

  /// Facteur d'échelle de la mise en page (référence : écran de 390 px).
  double get ui => (width / 390).clamp(0.88, 1.3).toDouble();

  /// Facteur de taille de texte choisi par l'utilisateur dans son téléphone.
  double get textScale => mq.textScaler.scale(10) / 10;
  double get layoutTextScale => textScale.clamp(1.0, 1.5).toDouble();

  double s(double v) => v * ui;
  double icon(double v) => mq.textScaler.scale(v * ui);
  double fit(double v) => v * ui * layoutTextScale;

  bool get isTablet => width >= 700;

  Duration get anim =>
      mq.disableAnimations ? Duration.zero : const Duration(milliseconds: 220);

  EdgeInsets get pageH => EdgeInsets.symmetric(horizontal: s(20));
}

extension MetricsContext on BuildContext {
  Metrics get m => Metrics.of(this);
}
