import 'package:flutter/material.dart';
import '../core/state/app_state.dart';
import '../core/utils/metrics.dart';

/// Choix de la taille du texte : Automatique (appareil), très petite, petite,
/// moyenne, grande.
class TextSizeSelector extends StatelessWidget {
  const TextSizeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final state = AppScope.of(context);

    return Column(
      children: [
        for (final option in TextSizeOption.values)
          Padding(
            padding: EdgeInsets.only(bottom: m.s(10)),
            child: Semantics(
              button: true,
              selected: state.textSize == option,
              label: 'Taille du texte ${option.label}',
              child: GestureDetector(
                onTap: () => state.setTextSize(option),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: m.anim,
                  padding: EdgeInsets.symmetric(horizontal: m.s(16), vertical: m.s(14)),
                  decoration: BoxDecoration(
                    color: state.textSize == option ? scheme.primaryContainer : scheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(m.s(16)),
                    border: Border.all(
                      color: state.textSize == option ? scheme.primary : scheme.outlineVariant,
                      width: state.textSize == option ? 2 : 1.3,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        state.textSize == option
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_unchecked_rounded,
                        size: m.icon(24),
                        color: state.textSize == option ? scheme.primary : scheme.outline,
                      ),
                      SizedBox(width: m.s(14)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(option.label, style: text.titleSmall),
                            if (option == TextSizeOption.auto)
                              Text(
                                'Suit les réglages de votre téléphone',
                                style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
