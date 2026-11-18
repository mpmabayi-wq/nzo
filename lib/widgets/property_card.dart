import 'package:flutter/material.dart';
import '../app.dart';
import '../core/state/app_state.dart';
import '../core/theme/app_themes.dart';
import '../core/utils/metrics.dart';
import '../data/property.dart';
import 'common.dart';
import 'property_art.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.propertyId});
  final String propertyId;

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final scheme = Theme.of(context).colorScheme;
    final state = AppScope.of(context);
    final fav = state.isFavorite(propertyId);
    return Semantics(
      button: true,
      label: fav ? 'Retirer des favoris' : 'Ajouter aux favoris',
      child: Material(
        color: scheme.surface.withValues(alpha: 0.92),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => state.toggleFavorite(propertyId),
          child: Padding(
            padding: EdgeInsets.all(m.s(9)),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 190),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                child: child,
              ),
              child: Icon(
                fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                key: ValueKey<bool>(fav),
                size: m.icon(22),
                color: fav ? const Color(0xFFE5484D) : scheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OfferBadge extends StatelessWidget {
  const OfferBadge({super.key, required this.offer});
  final String offer;

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final scheme = Theme.of(context).colorScheme;
    final rental = offer == 'Location';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: m.s(12), vertical: m.s(6)),
      decoration: BoxDecoration(
        color: rental ? scheme.surface.withValues(alpha: 0.94) : AppColors.gold,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        offer,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: rental ? scheme.primary : const Color(0xFF3A2600),
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

class _Spec extends StatelessWidget {
  const _Spec(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: m.s(10), vertical: m.s(6)),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: m.icon(16), color: scheme.onSurfaceVariant),
          SizedBox(width: m.s(6)),
          Flexible(
            child: Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: scheme.onSurfaceVariant)),
          ),
        ],
      ),
    );
  }
}

/// Carte éditoriale Nzo : visuel dominant, prix intégré et informations hiérarchisées.
class PropertyCard extends StatelessWidget {
  const PropertyCard({super.key, required this.property});
  final Property property;

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final p = property;
    return SoftCard(
      margin: EdgeInsets.only(bottom: m.s(17)),
      radius: 22,
      onTap: () => Navigator.pushNamed(context, AppRoutes.property, arguments: p),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PropertyArt(
          type: p.type,
          height: m.s(184),
          child: Stack(children: [
            Positioned(left: 13, top: 13, child: OfferBadge(offer: p.offer)),
            Positioned(right: 11, top: 10, child: FavoriteButton(propertyId: p.id)),
            Positioned(left: 13, bottom: 12, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: scheme.surface.withValues(alpha: .94), borderRadius: BorderRadius.circular(12)),
              child: Text.rich(TextSpan(text: p.priceText, style: text.titleMedium?.copyWith(color: scheme.primary, fontWeight: FontWeight.w800), children: [
                if (p.priceUnit.isNotEmpty) TextSpan(text: ' ${p.priceUnit}', style: text.labelSmall?.copyWith(color: scheme.onSurfaceVariant)),
              ])),
            )),
          ]),
        ),
        Padding(padding: EdgeInsets.fromLTRB(m.s(16), m.s(14), m.s(16), m.s(15)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.title, style: text.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
          SizedBox(height: m.s(7)),
          Row(children: [Icon(Icons.place_outlined, size: m.icon(17), color: scheme.primary), SizedBox(width: 5), Expanded(child: Text(p.placeLabel, maxLines: 1, overflow: TextOverflow.ellipsis, style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant))), const SizedBox(width: 8), Icon(Icons.arrow_outward_rounded, size: 17, color: scheme.onSurfaceVariant)]),
          SizedBox(height: m.s(12)),
          Divider(height: 1, color: scheme.outlineVariant),
          SizedBox(height: m.s(11)),
          Row(children: [
            Icon(iconForType(p.type), size: 17, color: scheme.onSurfaceVariant), const SizedBox(width: 6),
            Expanded(child: Text(p.type, maxLines: 1, overflow: TextOverflow.ellipsis, style: text.labelMedium?.copyWith(color: scheme.onSurfaceVariant))),
            if (p.bedrooms > 0) ...[Icon(Icons.bed_outlined, size: 17, color: scheme.onSurfaceVariant), const SizedBox(width: 5), Text('${p.bedrooms} ch.', style: text.labelMedium?.copyWith(color: scheme.onSurfaceVariant))],
          ]),
        ])),
      ]),
    );
  }
}

/// Carte compacte pour le carrousel « À la une ».
class FeaturedCard extends StatelessWidget {
  const FeaturedCard({super.key, required this.property});
  final Property property;

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final p = property;

    return SizedBox(
      width: m.s(272),
      child: SoftCard(
        radius: 22,
        onTap: () => Navigator.pushNamed(context, AppRoutes.property, arguments: p),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PropertyArt(
              type: p.type,
              height: m.s(132),
              child: Stack(
                children: [
                  Positioned(left: m.s(10), top: m.s(10), child: OfferBadge(offer: p.offer)),
                  Positioned(right: m.s(8), top: m.s(8), child: FavoriteButton(propertyId: p.id)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(m.s(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: p.priceText,
                      style: text.titleLarge?.copyWith(color: scheme.primary),
                      children: [
                        if (p.priceUnit.isNotEmpty)
                          TextSpan(
                            text: ' ${p.priceUnit}',
                            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: m.s(4)),
                  Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: text.titleSmall),
                  SizedBox(height: m.s(4)),
                  Text(p.placeLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
