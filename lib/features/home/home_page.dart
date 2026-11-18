import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/utils/metrics.dart';
import '../../data/property.dart';
import '../../widgets/common.dart';
import '../../widgets/property_card.dart';
import '../../widgets/page_sliver_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onSearch});
  final void Function(SearchRequest request) onSearch;

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final state = AppScope.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final featured = state.properties.take(5).toList();
    final greeting = DateTime.now().hour < 18 ? 'BONJOUR' : 'BONSOIR';

    return CustomScrollView(
      key: const PageStorageKey<String>('nzo-home-scroll'),
      slivers: [
        NzoSliverHeader(
          title: 'Découvrir', eyebrow: greeting,
          subtitle: 'Des lieux qui vous ressemblent, près de chez vous.',
          actions: [
            Padding(padding: const EdgeInsets.only(right: 16), child: Center(child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(30)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.location_on_outlined, size: 16, color: scheme.primary), const SizedBox(width: 4), Text('Matadi', style: text.labelMedium?.copyWith(color: scheme.onPrimaryContainer))]),
            ))),
          ],
        ),
        SliverToBoxAdapter(child: Padding(
          padding: EdgeInsets.fromLTRB(m.s(20), m.s(12), m.s(20), m.s(22)),
          child: Material(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => onSearch(const SearchRequest()),
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15), child: Row(children: [
                Icon(Icons.search_rounded, color: scheme.primary, size: 23), const SizedBox(width: 12),
                Expanded(child: Text('Un quartier, un logement…', style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant))),
                Container(width: 36, height: 36, decoration: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(12)), child: Icon(Icons.tune_rounded, color: scheme.onPrimary, size: 19)),
              ])),
            ),
          ),
        )),
        SliverToBoxAdapter(child: Padding(padding: m.pageH, child: Row(children: [
          Expanded(child: _ExploreTile(title: 'Louer', caption: 'Trouver un chez-soi', icon: Icons.vpn_key_outlined, tint: scheme.primaryContainer, foreground: scheme.onPrimaryContainer, onTap: () => onSearch(const SearchRequest(offer: 'Location')))),
          SizedBox(width: m.s(12)),
          Expanded(child: _ExploreTile(title: 'Acheter', caption: 'Votre prochain projet', icon: Icons.real_estate_agent_outlined, tint: scheme.secondaryContainer, foreground: scheme.onSecondaryContainer, onTap: () => onSearch(const SearchRequest(offer: 'Vente')))),
        ]))),
        SliverToBoxAdapter(child: Padding(padding: EdgeInsets.fromLTRB(m.s(20), m.s(27), m.s(20), m.s(12)), child: const SectionHeader(title: 'Explorer par type'))),
        SliverToBoxAdapter(child: SizedBox(height: 94, child: ListView(scrollDirection: Axis.horizontal, padding: m.pageH, children: [
          _CategoryItem('Maisons', Icons.house_outlined, () => onSearch(const SearchRequest(type: 'Maison'))),
          _CategoryItem('Appartements', Icons.apartment_rounded, () => onSearch(const SearchRequest(type: 'Appartement'))),
          _CategoryItem('Studios', Icons.bed_outlined, () => onSearch(const SearchRequest(type: 'Chambre / Studio'))),
          _CategoryItem('Parcelles', Icons.landscape_outlined, () => onSearch(const SearchRequest(type: 'Parcelle'))),
          _CategoryItem('Commerces', Icons.storefront_outlined, () => onSearch(const SearchRequest(type: 'Local commercial'))),
        ]))),
        SliverToBoxAdapter(child: Padding(padding: EdgeInsets.fromLTRB(m.s(20), m.s(27), m.s(20), m.s(12)), child: SectionHeader(title: 'Sélection Nzo', actionLabel: 'Tout voir', onAction: () => onSearch(const SearchRequest())))),
        SliverToBoxAdapter(child: SizedBox(height: m.s(290), child: ListView.separated(
          scrollDirection: Axis.horizontal, padding: m.pageH, itemCount: featured.length,
          separatorBuilder: (_, __) => SizedBox(width: m.s(13)),
          itemBuilder: (_, i) => FeaturedCard(property: featured[i]),
        ))),
        SliverToBoxAdapter(child: Padding(padding: EdgeInsets.fromLTRB(m.s(20), m.s(22), m.s(20), m.s(12)), child: const SectionHeader(title: 'Ajouts récents'))),
        SliverPadding(padding: EdgeInsets.fromLTRB(m.s(20), 0, m.s(20), m.s(30)), sliver: SliverList(delegate: SliverChildBuilderDelegate(
          (context, index) => PropertyCard(property: state.properties[index]), childCount: state.properties.length,
        ))),
      ],
    );
  }
}

class _ExploreTile extends StatelessWidget {
  const _ExploreTile({required this.title, required this.caption, required this.icon, required this.tint, required this.foreground, required this.onTap});
  final String title, caption; final IconData icon; final Color tint, foreground; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(color: tint, borderRadius: BorderRadius.circular(20), child: InkWell(
    borderRadius: BorderRadius.circular(20), onTap: onTap,
    child: Padding(padding: const EdgeInsets.all(15), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: foreground, size: 25), const SizedBox(height: 15),
      Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: foreground)),
      const SizedBox(height: 3), Text(caption, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: foreground.withValues(alpha: .78))),
    ])),
  ));
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem(this.label, this.icon, this.onTap);
  final String label; final IconData icon; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(padding: const EdgeInsets.only(right: 18), child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: SizedBox(width: 76, child: Column(children: [
      Container(width: 54, height: 54, decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(17), border: Border.all(color: scheme.outlineVariant)), child: Icon(icon, color: scheme.primary, size: 25)),
      const SizedBox(height: 7), Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelSmall),
    ]))));
  }
}
