import 'package:flutter/material.dart';

/// Identité visuelle Nzo : deux univers sobres, dessinés pour rester lisibles.
class AppColors {
  static const brand = Color(0xFF174A43);
  static const brandLight = Color(0xFF2D7467);
  static const brandDeep = Color(0xFF103A35);
  static const gold = Color(0xFFD7A85B);
  static const goldDeep = Color(0xFFB98235);
  static const whatsapp = Color(0xFF1FAF5A);
}

class ThemeOption {
  final String name;
  final String description;
  final Color seed;
  final Color accent;
  const ThemeOption({required this.name, required this.description, required this.seed, required this.accent});
}

class AppThemes {
  static const options = <ThemeOption>[
    ThemeOption(name: 'Atelier', description: 'Vert profond, ivoire et cuivre — chaleureux et intemporel.', seed: Color(0xFF174A43), accent: Color(0xFFD7A85B)),
    ThemeOption(name: 'Minéral', description: 'Ardoise, brume et bleu pétrole — net et contemporain.', seed: Color(0xFF34566A), accent: Color(0xFFC69B69)),
  ];

  static ThemeData light({int themeIndex = 0}) => _build(Brightness.light, themeIndex);
  static ThemeData dark({int themeIndex = 0}) => _build(Brightness.dark, themeIndex);

  static ThemeData _build(Brightness brightness, int themeIndex) {
    final dark = brightness == Brightness.dark;
    final option = options[themeIndex.clamp(0, options.length - 1).toInt()];
    final seed = option.seed;
    final bg = dark ? const Color(0xFF101918) : const Color(0xFFF6F4EF);
    final surface = dark ? const Color(0xFF192321) : const Color(0xFFFFFEFB);
    final text = dark ? const Color(0xFFECEFEB) : const Color(0xFF202A27);
    final muted = dark ? const Color(0xFFA5B3AD) : const Color(0xFF718079);
    final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness).copyWith(
      primary: dark ? Color.lerp(seed, Colors.white, .22)! : seed,
      onPrimary: Colors.white,
      secondary: option.accent,
      onSecondary: const Color(0xFF292116),
      surface: bg,
      onSurface: text,
      surfaceContainerLowest: surface,
      surfaceContainerLow: surface,
      surfaceContainer: dark ? const Color(0xFF202D29) : const Color(0xFFEDEFE9),
      surfaceContainerHigh: dark ? const Color(0xFF293833) : const Color(0xFFE4E9E2),
      surfaceContainerHighest: dark ? const Color(0xFF34443E) : const Color(0xFFDCE3DC),
      onSurfaceVariant: muted,
      outline: dark ? const Color(0xFF53635C) : const Color(0xFF9BA69E),
      outlineVariant: dark ? const Color(0xFF34443E) : const Color(0xFFDCE2DA),
      primaryContainer: dark ? const Color(0xFF29463E) : Color.lerp(seed, Colors.white, .88)!,
      onPrimaryContainer: dark ? const Color(0xFFE5F0EA) : const Color(0xFF173B34),
      secondaryContainer: dark ? const Color(0xFF493B27) : const Color(0xFFF3E8D6),
      onSecondaryContainer: dark ? const Color(0xFFF4E5CC) : const Color(0xFF4A3820),
      error: dark ? const Color(0xFFFF8A80) : const Color(0xFFB3261E),
    );
    final base = ThemeData(useMaterial3: true, colorScheme: scheme, scaffoldBackgroundColor: bg,
      fontFamily: 'Roboto', splashFactory: InkSparkle.splashFactory);
    OutlineInputBorder inputBorder(Color color, [double width = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: color, width: width));
    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, height: 1.12, letterSpacing: -1.1),
        headlineMedium: const TextStyle(fontSize: 27, fontWeight: FontWeight.w800, height: 1.16, letterSpacing: -.8),
        headlineSmall: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800, height: 1.2, letterSpacing: -.5),
        titleLarge: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700, height: 1.25, letterSpacing: -.25),
        titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, height: 1.3),
        bodyLarge: const TextStyle(fontSize: 16, height: 1.45),
        bodyMedium: const TextStyle(fontSize: 14, height: 1.45),
        bodySmall: const TextStyle(fontSize: 12, height: 1.4),
      ).apply(bodyColor: text, displayColor: text),
      appBarTheme: AppBarTheme(backgroundColor: bg, foregroundColor: text, elevation: 0, scrolledUnderElevation: 0),
      cardTheme: CardThemeData(color: surface, elevation: 0, margin: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22), side: BorderSide(color: scheme.outlineVariant))),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700))),
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), side: BorderSide(color: scheme.outlineVariant))),
      inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: surface, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), hintStyle: TextStyle(color: muted), border: inputBorder(scheme.outlineVariant), enabledBorder: inputBorder(scheme.outlineVariant), focusedBorder: inputBorder(scheme.primary, 1.6), errorBorder: inputBorder(scheme.error)),
      navigationBarTheme: NavigationBarThemeData(height: 72, elevation: 0, backgroundColor: surface, indicatorColor: scheme.primaryContainer, labelTextStyle: WidgetStateProperty.resolveWith((s) => TextStyle(fontSize: 11, fontWeight: s.contains(WidgetState.selected) ? FontWeight.w800 : FontWeight.w500, color: s.contains(WidgetState.selected) ? scheme.primary : muted))),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: surface, showDragHandle: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26)))),
      snackBarTheme: SnackBarThemeData(behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1, space: 1),
    );
  }
}
