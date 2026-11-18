import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_themes.dart';
import '../../core/utils/metrics.dart';
import '../../data/property.dart';
import '../../widgets/common.dart';
import '../../widgets/property_art.dart';
import '../../widgets/property_card.dart';

class PropertyDetailPage extends StatelessWidget {
  const PropertyDetailPage({super.key, required this.property});

  final Property property;

  void _showContact(BuildContext context, String mode) {
    // À brancher plus tard avec url_launcher (appel direct / WhatsApp).
    showModalBottomSheet<void>(
      context: context,
      builder: (sheet) {
        final m = sheet.m;
        final scheme = Theme.of(sheet).colorScheme;
        final text = Theme.of(sheet).textTheme;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(m.s(24), 0, m.s(24), m.s(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(mode, style: text.titleLarge, textAlign: TextAlign.center),
                SizedBox(height: m.s(6)),
                Text('${property.contactName} · ${property.contactRole}',
                    textAlign: TextAlign.center,
                    style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                SizedBox(height: m.s(18)),
                Container(
                  padding: EdgeInsets.symmetric(vertical: m.s(18)),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(m.s(18)),
                  ),
                  child: Text(
                    property.phone,
                    textAlign: TextAlign.center,
                    style: text.headlineSmall?.copyWith(color: scheme.onPrimaryContainer),
                  ),
                ),
                SizedBox(height: m.s(16)),
                FilledButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: property.phone));
                    Navigator.pop(sheet);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Numéro copié')),
                    );
                  },
                  icon: Icon(Icons.copy_rounded, size: m.icon(20)),
                  label: const Text('Copier le numéro'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final p = property;
    final state = AppScope.of(context);
    final fav = state.isFavorite(p.id);

    Widget roundButton(IconData icon, VoidCallback onTap, String label, {Color? color}) {
      return Center(
        child: SizedBox(
          width: m.s(42),
          height: m.s(42),
          child: Semantics(
            button: true,
            label: label,
            child: Material(
              color: scheme.surface.withValues(alpha: 0.92),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onTap,
                child: Center(
                  child: Icon(icon, size: m.icon(22), color: color ?? scheme.onSurface),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          border: Border(top: BorderSide(color: scheme.outlineVariant)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(m.s(20), m.s(12), m.s(20), m.s(12)),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _showContact(context, 'Appeler'),
                    icon: Icon(Icons.call_rounded, size: m.icon(20)),
                    label: const Text('Appeler'),
                  ),
                ),
                SizedBox(width: m.s(12)),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showContact(context, 'WhatsApp'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.whatsapp,
                      side: const BorderSide(color: AppColors.whatsapp, width: 1.6),
                    ),
                    icon: Icon(Icons.chat_rounded, size: m.icon(20)),
                    label: const Text('WhatsApp'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: m.s(290),
                backgroundColor: paletteForType(p.type).first,
                surfaceTintColor: Colors.transparent,
                leadingWidth: m.s(62),
                leading: roundButton(Icons.arrow_back_rounded, () => Navigator.pop(context), 'Retour'),
                actions: [
                  roundButton(
                    fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    () => state.toggleFavorite(p.id),
                    fav ? 'Retirer des favoris' : 'Ajouter aux favoris',
                    color: fav ? const Color(0xFFE5484D) : null,
                  ),
                  SizedBox(width: m.s(6)),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: PropertyArt(type: p.type),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(m.s(20), m.s(20), m.s(20), m.s(28)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          OfferBadge(offer: p.offer),
                          SizedBox(width: m.s(8)),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: m.s(12), vertical: m.s(6)),
                            decoration: BoxDecoration(
                              color: scheme.primaryContainer,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(p.type,
                                style: text.labelMedium
                                    ?.copyWith(color: scheme.onPrimaryContainer)),
                          ),
                        ],
                      ),
                      SizedBox(height: m.s(14)),
                      Text.rich(
                        TextSpan(
                          text: p.priceText,
                          style: text.headlineMedium?.copyWith(color: scheme.primary),
                          children: [
                            if (p.priceUnit.isNotEmpty)
                              TextSpan(
                                text: '  ${p.priceUnit}',
                                style: text.titleSmall?.copyWith(color: scheme.onSurfaceVariant),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: m.s(8)),
                      Text(p.title, style: text.titleLarge),
                      SizedBox(height: m.s(10)),
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded, size: m.icon(20), color: scheme.primary),
                          SizedBox(width: m.s(6)),
                          Expanded(
                            child: Text(p.placeLabel,
                                style: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant)),
                          ),
                        ],
                      ),
                      SizedBox(height: m.s(22)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: _Stat(iconForType(p.type), 'Type', p.type)),
                          SizedBox(width: m.s(10)),
                          Expanded(
                            child: p.bedrooms > 0
                                ? _Stat(Icons.bed_rounded, 'Chambres', '${p.bedrooms}')
                                : _Stat(Icons.map_rounded, 'Commune', p.commune),
                          ),
                          SizedBox(width: m.s(10)),
                          Expanded(
                            child: _Stat(p.isRental ? Icons.key_rounded : Icons.sell_rounded,
                                'Offre', p.offer),
                          ),
                        ],
                      ),
                      SizedBox(height: m.s(26)),
                      Text('Description', style: text.titleMedium),
                      SizedBox(height: m.s(8)),
                      Text(p.description, style: text.bodyLarge?.copyWith(height: 1.55)),
                      SizedBox(height: m.s(26)),
                      Text('Contact', style: text.titleMedium),
                      SizedBox(height: m.s(12)),
                      SoftCard(
                        padding: EdgeInsets.all(m.s(16)),
                        child: Row(
                          children: [
                            Container(
                              width: m.s(52),
                              height: m.s(52),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [AppColors.brandLight, AppColors.brandDeep],
                                ),
                              ),
                              child: Text(
                                p.contactName.substring(0, 1).toUpperCase(),
                                style: text.titleLarge?.copyWith(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: m.s(14)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.contactName, style: text.titleMedium),
                                  SizedBox(height: m.s(2)),
                                  Text(p.contactRole,
                                      style: text.bodyMedium
                                          ?.copyWith(color: scheme.onSurfaceVariant)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: m.s(16)),
                      Container(
                        padding: EdgeInsets.all(m.s(14)),
                        decoration: BoxDecoration(
                          color: scheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(m.s(16)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.lightbulb_rounded,
                                size: m.icon(22), color: scheme.onSecondaryContainer),
                            SizedBox(width: m.s(10)),
                            Expanded(
                              child: Text(
                                'Conseil : visitez toujours le bien avant de verser le moindre paiement.',
                                style: text.bodyMedium
                                    ?.copyWith(color: scheme.onSecondaryContainer),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(vertical: m.s(14), horizontal: m.s(10)),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(m.s(18)),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(icon, size: m.icon(24), color: scheme.primary),
          SizedBox(height: m.s(8)),
          Text(value,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: text.labelLarge),
          SizedBox(height: m.s(2)),
          Text(label,
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
