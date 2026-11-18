import 'package:flutter/material.dart';

/// En-tête commun Nzo : grand titre éditorial qui se contracte au défilement.
class NzoSliverHeader extends StatelessWidget {
  const NzoSliverHeader({super.key, required this.title, this.eyebrow, this.subtitle, this.actions = const [], this.leading});
  final String title;
  final String? eyebrow;
  final String? subtitle;
  final List<Widget> actions;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      expandedHeight: subtitle == null ? 116 : 142,
      toolbarHeight: 62,
      automaticallyImplyLeading: false,
      leading: leading,
      actions: actions,
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      flexibleSpace: LayoutBuilder(builder: (context, constraints) {
        final compact = constraints.maxHeight < 105;
        return FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          titlePadding: const EdgeInsetsDirectional.only(start: 20, bottom: 15),
          title: AnimatedOpacity(
            duration: const Duration(milliseconds: 160),
            opacity: compact ? 1 : 0,
            child: Text(title, style: text.titleLarge?.copyWith(fontSize: 17), maxLines: 1),
          ),
          background: Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 18),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 140),
                  opacity: compact ? 0 : 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (eyebrow != null) Text(eyebrow!.toUpperCase(), style: text.labelSmall?.copyWith(color: scheme.primary, letterSpacing: 1.5, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(title, style: text.headlineSmall?.copyWith(fontSize: 26)),
                      if (subtitle != null) ...[
                        const SizedBox(height: 3),
                        Text(subtitle!, style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                      ],
                    ],
                  ),
                ),
              ),
          ),
        );
      }),
    );
  }
}
