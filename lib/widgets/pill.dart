import 'package:flutter/material.dart';
import '../core/utils/metrics.dart';

/// Bouton « pastille » sélectionnable (filtres, choix du type de bien...).
class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final scheme = Theme.of(context).colorScheme;
    final fg = selected ? scheme.onPrimary : scheme.onSurface;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: m.anim,
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: m.s(16), vertical: m.s(10)),
          decoration: BoxDecoration(
            color: selected ? scheme.primary : scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: selected ? scheme.primary : scheme.outlineVariant),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: m.icon(18), color: fg),
                SizedBox(width: m.s(6)),
              ],
              Text(label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: fg)),
            ],
          ),
        ),
      ),
    );
  }
}
