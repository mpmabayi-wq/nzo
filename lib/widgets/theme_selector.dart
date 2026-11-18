import 'package:flutter/material.dart';
import '../core/state/app_state.dart';
import '../core/theme/app_themes.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Column(children: [
      for (var i = 0; i < AppThemes.options.length; i++) ...[
        if (i > 0) const SizedBox(height: 10),
        Semantics(button: true, selected: state.themeIndex == i,
          child: InkWell(borderRadius: BorderRadius.circular(18), onTap: () => state.setTheme(i),
            child: AnimatedContainer(duration: const Duration(milliseconds: 220), padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: state.themeIndex == i ? scheme.primaryContainer.withValues(alpha: .58) : scheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18), border: Border.all(color: state.themeIndex == i ? scheme.primary : scheme.outlineVariant, width: state.themeIndex == i ? 1.7 : 1)),
              child: Row(children: [
                Container(width: 48, height: 48, decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppThemes.options[i].seed, AppThemes.options[i].accent])),
                  child: const Icon(Icons.architecture_rounded, color: Colors.white, size: 23)),
                const SizedBox(width: 13),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(AppThemes.options[i].name, style: text.titleMedium),
                  const SizedBox(height: 3),
                  Text(AppThemes.options[i].description, style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                ])),
                const SizedBox(width: 8),
                Icon(state.themeIndex == i ? Icons.check_circle_rounded : Icons.circle_outlined, color: state.themeIndex == i ? scheme.primary : scheme.outline, size: 23),
              ]),
            ),
          ),
        ),
      ],
    ]);
  }
}
