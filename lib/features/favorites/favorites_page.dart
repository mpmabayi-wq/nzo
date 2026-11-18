import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/utils/metrics.dart';
import '../../widgets/common.dart';
import '../../widgets/property_card.dart';
import '../../widgets/page_sliver_header.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key, required this.onExplore});
  final VoidCallback onExplore;
  @override
  Widget build(BuildContext context) {
    final m = context.m; final state = AppScope.of(context);
    final favs = state.properties.where((p) => state.isFavorite(p.id)).toList();
    return CustomScrollView(key: const PageStorageKey<String>('nzo-favorites-scroll'), slivers: [
      NzoSliverHeader(title: 'Vos favoris', eyebrow: 'VOTRE SÉLECTION', subtitle: favs.isEmpty ? 'Les lieux que vous souhaitez garder.' : '${favs.length} annonce${favs.length > 1 ? 's' : ''} mise${favs.length > 1 ? 's' : ''} de côté.'),
      if (favs.isEmpty) SliverToBoxAdapter(child: EmptyState(icon: Icons.bookmark_border_rounded, title: 'Votre sélection est vide', message: 'Touchez le marque-page d’une annonce pour la retrouver ici.', actionLabel: 'Explorer les biens', onAction: onExplore))
      else SliverPadding(padding: EdgeInsets.fromLTRB(m.s(20), m.s(10), m.s(20), m.s(30)), sliver: SliverList(delegate: SliverChildBuilderDelegate((context, index) => PropertyCard(property: favs[index]), childCount: favs.length))),
    ]);
  }
}
