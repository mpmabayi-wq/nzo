import 'package:flutter/material.dart';
import '../core/utils/metrics.dart';

/// Carte douce utilisée partout (fond, bordure fine, ombre légère en mode clair).
class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.radius = 22,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final light = scheme.brightness == Brightness.light;
    final r = BorderRadius.circular(context.m.s(radius));
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: r,
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.85)),
        boxShadow: light
            ? const [BoxShadow(color: Color(0x0D172C25), blurRadius: 18, offset: Offset(0, 6))]
            : null,
      ),
      child: ClipRRect(
        borderRadius: r,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        if (actionLabel != null) TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.title, this.subtitle, this.trailing});

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(m.s(20), m.s(18), m.s(20), m.s(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.headlineSmall),
                if (subtitle != null) ...[
                  SizedBox(height: m.s(4)),
                  Text(subtitle!,
                      style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: m.s(32), vertical: m.s(40)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(m.s(24)),
            decoration: BoxDecoration(color: scheme.primaryContainer, shape: BoxShape.circle),
            child: Icon(icon, size: m.icon(44), color: scheme.primary),
          ),
          SizedBox(height: m.s(20)),
          Text(title, style: text.titleLarge, textAlign: TextAlign.center),
          SizedBox(height: m.s(8)),
          Text(message,
              style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              textAlign: TextAlign.center),
          if (actionLabel != null) ...[
            SizedBox(height: m.s(24)),
            FilledButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

/// Rangée horizontale défilante (filtres, catégories...).
class HScroll extends StatelessWidget {
  const HScroll({super.key, required this.children, this.gap = 10});

  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: m.pageH,
      child: Row(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(width: m.s(gap)),
            children[i],
          ],
        ],
      ),
    );
  }
}
