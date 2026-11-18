import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/utils/metrics.dart';
import '../../data/property.dart';
import '../../widgets/common.dart';
import '../../widgets/property_card.dart';
import '../../widgets/page_sliver_header.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.request});
  final ValueNotifier<SearchRequest?> request;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  String _offer = 'Tous', _type = 'Tous', _commune = 'Toutes';
  @override
  void initState() { super.initState(); widget.request.addListener(_onRequest); }
  @override
  void dispose() { widget.request.removeListener(_onRequest); _controller.dispose(); super.dispose(); }
  void _onRequest() {
    final r = widget.request.value; if (r == null) return;
    setState(() { _offer = r.offer ?? 'Tous'; _type = r.type ?? 'Tous'; _commune = 'Toutes'; _controller.clear(); });
    widget.request.value = null;
  }
  void _reset() => setState(() { _offer = 'Tous'; _type = 'Tous'; _commune = 'Toutes'; _controller.clear(); });

  Future<void> _showFilters() async {
    var offer = _offer, type = _type, commune = _commune;
    final result = await showModalBottomSheet<bool>(context: context, isScrollControlled: true, builder: (sheet) {
      final scheme = Theme.of(sheet).colorScheme;
      Widget group(String title, List<String> values, String selected, ValueChanged<String> change) => Padding(
        padding: const EdgeInsets.only(bottom: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(sheet).textTheme.titleSmall), const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: values.map((v) => ChoiceChip(label: Text(v), selected: selected == v, onSelected: (_) => change(v))).toList()),
        ]));
      return StatefulBuilder(builder: (context, setSheet) => SafeArea(child: Padding(
        padding: EdgeInsets.fromLTRB(22, 8, 22, 22 + MediaQuery.viewInsetsOf(sheet).bottom),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [Expanded(child: Text('Affiner la recherche', style: Theme.of(sheet).textTheme.titleLarge)), IconButton(onPressed: () => Navigator.pop(sheet, false), icon: const Icon(Icons.close_rounded))]),
          const SizedBox(height: 12),
          group('Transaction', ['Tous', ...kOffers], offer, (v) => setSheet(() => offer = v)),
          group('Type de bien', ['Tous', ...kTypes], type, (v) => setSheet(() => type = v)),
          group('Commune', ['Toutes', ...kCommunes], commune, (v) => setSheet(() => commune = v)),
          Row(children: [TextButton(onPressed: () => setSheet(() { offer = 'Tous'; type = 'Tous'; commune = 'Toutes'; }), child: const Text('Effacer')), const Spacer(), FilledButton.icon(onPressed: () { _offer = offer; _type = type; _commune = commune; Navigator.pop(sheet, true); }, icon: const Icon(Icons.check_rounded), label: const Text('Afficher les biens'))]),
          const SizedBox(height: 4),
          Container(height: 1, color: scheme.outlineVariant),
        ]),
      )));
    });
    if (result == true && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final m = context.m; final state = AppScope.of(context); final scheme = Theme.of(context).colorScheme; final text = Theme.of(context).textTheme;
    final query = _controller.text.trim().toLowerCase();
    final results = state.properties.where((p) {
      if (_offer != 'Tous' && p.offer != _offer) return false;
      if (_type != 'Tous' && p.type != _type) return false;
      if (_commune != 'Toutes' && p.commune != _commune) return false;
      return query.isEmpty || '${p.title} ${p.quartier} ${p.commune} ${p.type}'.toLowerCase().contains(query);
    }).toList();
    final filtering = _offer != 'Tous' || _type != 'Tous' || _commune != 'Toutes' || query.isNotEmpty;
    final activeCount = [_offer != 'Tous', _type != 'Tous', _commune != 'Toutes'].where((v) => v).length;

    return CustomScrollView(key: const PageStorageKey<String>('nzo-search-scroll'), slivers: [
      NzoSliverHeader(title: 'Recherche', eyebrow: 'TROUVER VOTRE ESPACE', subtitle: 'Quelques critères suffisent pour trouver le bon lieu.'),
      SliverToBoxAdapter(child: Padding(padding: EdgeInsets.fromLTRB(m.s(20), m.s(8), m.s(20), m.s(14)), child: Row(children: [
        Expanded(child: TextField(controller: _controller, onChanged: (_) => setState(() {}), textInputAction: TextInputAction.search, decoration: InputDecoration(hintText: 'Quartier, commune, type…', prefixIcon: const Icon(Icons.search_rounded), suffixIcon: _controller.text.isEmpty ? null : IconButton(onPressed: () { _controller.clear(); setState(() {}); }, icon: const Icon(Icons.close_rounded)), contentPadding: const EdgeInsets.symmetric(vertical: 13)))),
        const SizedBox(width: 10),
        Material(color: activeCount > 0 ? scheme.primary : scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(15), child: InkWell(onTap: _showFilters, borderRadius: BorderRadius.circular(15), child: SizedBox(width: 54, height: 54, child: Stack(alignment: Alignment.center, children: [Icon(Icons.tune_rounded, color: activeCount > 0 ? scheme.onPrimary : scheme.primary), if (activeCount > 0) Positioned(right: 8, top: 7, child: Container(width: 8, height: 8, decoration: BoxDecoration(color: scheme.secondary, shape: BoxShape.circle)))])))),
      ]))),
      SliverToBoxAdapter(child: Padding(padding: EdgeInsets.fromLTRB(m.s(20), 0, m.s(20), m.s(16)), child: Wrap(spacing: 8, runSpacing: 8, children: [
        _QuickFilter(label: 'Tout', selected: _offer == 'Tous', onTap: () => setState(() => _offer = 'Tous')),
        _QuickFilter(label: 'À louer', selected: _offer == 'Location', onTap: () => setState(() => _offer = 'Location')),
        _QuickFilter(label: 'À vendre', selected: _offer == 'Vente', onTap: () => setState(() => _offer = 'Vente')),
        OutlinedButton.icon(onPressed: _showFilters, icon: const Icon(Icons.filter_list_rounded, size: 17), label: Text(activeCount == 0 ? 'Filtres' : 'Filtres ($activeCount)'), style: OutlinedButton.styleFrom(minimumSize: const Size(0, 38), padding: const EdgeInsets.symmetric(horizontal: 13))),
      ]))),
      SliverToBoxAdapter(child: Padding(padding: EdgeInsets.fromLTRB(m.s(20), 0, m.s(20), m.s(12)), child: Row(children: [Expanded(child: Text(results.length == 1 ? '1 bien trouvé' : '${results.length} biens trouvés', style: text.titleMedium)), if (filtering) TextButton(onPressed: _reset, child: const Text('Réinitialiser'))]))),
      if (results.isEmpty) SliverToBoxAdapter(child: EmptyState(icon: Icons.search_off_rounded, title: 'Aucun bien trouvé', message: 'Modifiez vos critères ou essayez un autre quartier.', actionLabel: 'Effacer les filtres', onAction: _reset))
      else SliverPadding(padding: EdgeInsets.fromLTRB(m.s(20), 0, m.s(20), m.s(30)), sliver: SliverList(delegate: SliverChildBuilderDelegate((context, index) => PropertyCard(property: results[index]), childCount: results.length))),
    ]);
  }
}

class _QuickFilter extends StatelessWidget {
  const _QuickFilter({required this.label, required this.selected, required this.onTap});
  final String label; final bool selected; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) { final scheme = Theme.of(context).colorScheme; return Material(color: selected ? scheme.primary : scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(30), child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(30), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), child: Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: selected ? scheme.onPrimary : scheme.onSurface, fontWeight: FontWeight.w700))))); }
}
