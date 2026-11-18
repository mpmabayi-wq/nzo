import 'package:flutter/material.dart';
import '../core/state/app_state.dart';
import '../core/utils/metrics.dart';

IconData themeModeIcon(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return Icons.light_mode_rounded;
    case ThemeMode.dark:
      return Icons.dark_mode_rounded;
    case ThemeMode.system:
      return Icons.brightness_auto_rounded;
  }
}

String themeModeLabel(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return 'Clair';
    case ThemeMode.dark:
      return 'Sombre';
    case ThemeMode.system:
      return 'Automatique';
  }
}

/// Trois cartes : Automatique (réglage du téléphone) / Clair / Sombre.
class ThemeModeCards extends StatelessWidget {
  const ThemeModeCards({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final state = AppScope.of(context);

    return Row(
      children: [
        for (final mode in ThemeMode.values) ...[
          if (mode != ThemeMode.values.first) SizedBox(width: m.s(10)),
          Expanded(
            child: Semantics(
              button: true,
              selected: state.themeMode == mode,
              label: 'Thème ${themeModeLabel(mode)}',
              child: GestureDetector(
                onTap: () => state.setThemeMode(mode),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: m.anim,
                  padding: EdgeInsets.symmetric(vertical: m.s(16), horizontal: m.s(6)),
                  decoration: BoxDecoration(
                    color: state.themeMode == mode
                        ? scheme.primaryContainer
                        : scheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(m.s(18)),
                    border: Border.all(
                      color: state.themeMode == mode ? scheme.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(themeModeIcon(mode),
                          size: m.icon(28),
                          color: state.themeMode == mode
                              ? scheme.primary
                              : scheme.onSurfaceVariant),
                      SizedBox(height: m.s(8)),
                      Text(
                        themeModeLabel(mode),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.labelMedium?.copyWith(
                          color: state.themeMode == mode
                              ? scheme.onPrimaryContainer
                              : scheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Bouton rond (coin haut droit) qui ouvre le choix du thème.
class ThemeModeButton extends StatelessWidget {
  const ThemeModeButton({super.key, this.onHero = false});

  final bool onHero;

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final scheme = Theme.of(context).colorScheme;
    final state = AppScope.of(context);

    return Tooltip(
      message: 'Apparence',
      child: Material(
        color: onHero ? Colors.white.withValues(alpha: 0.18) : scheme.surfaceContainerLow,
        shape: CircleBorder(
          side: BorderSide(
            color: onHero ? Colors.white.withValues(alpha: 0.30) : scheme.outlineVariant,
          ),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => showThemeModeSheet(context),
          child: Padding(
            padding: EdgeInsets.all(m.s(12)),
            child: Icon(
              themeModeIcon(state.themeMode),
              size: m.icon(24),
              color: onHero ? Colors.white : scheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showThemeModeSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      final m = sheetContext.m;
      final text = Theme.of(sheetContext).textTheme;
      final scheme = Theme.of(sheetContext).colorScheme;
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(m.s(20), 0, m.s(20), m.s(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Apparence', style: text.titleLarge),
              SizedBox(height: m.s(4)),
              Text(
                'Automatique suit le réglage clair ou sombre de votre téléphone.',
                style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
              SizedBox(height: m.s(18)),
              const ThemeModeCards(),
              SizedBox(height: m.s(8)),
            ],
          ),
        ),
      );
    },
  );
}
