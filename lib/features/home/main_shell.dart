import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../core/utils/metrics.dart';
import '../favorites/favorites_page.dart';
import '../profile/profile_page.dart';
import '../publish/publish_page.dart';
import '../search/search_page.dart';
import 'home_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  final ValueNotifier<SearchRequest?> _searchRequest = ValueNotifier<SearchRequest?>(null);

  void _goTo(int i) => setState(() => _index = i);

  void _openSearch(SearchRequest request) {
    _searchRequest.value = request;
    _goTo(1);
  }

  @override
  void dispose() {
    _searchRequest.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = context.m;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: IndexedStack(
              index: _index,
              children: [
                HomePage(onSearch: _openSearch),
                SearchPage(request: _searchRequest),
                PublishPage(onPublished: () => _goTo(0)),
                FavoritesPage(onExplore: () => _goTo(0)),
                const ProfilePage(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
        ),
        child: NavigationBar(
        animationDuration: const Duration(milliseconds: 260),
        selectedIndex: _index,
        onDestinationSelected: _goTo,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined, size: m.icon(23)),
            selectedIcon: Icon(Icons.explore_rounded, size: m.icon(23)),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.travel_explore_outlined, size: m.icon(23)),
            selectedIcon: Icon(Icons.travel_explore_rounded, size: m.icon(23)),
            label: 'Chercher',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box_outlined, size: m.icon(23)),
            selectedIcon: Icon(Icons.add_box_rounded, size: m.icon(23)),
            label: 'Publier',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border_rounded, size: m.icon(23)),
            selectedIcon: Icon(Icons.bookmark_rounded, size: m.icon(23)),
            label: 'Favoris',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined, size: m.icon(23)),
            selectedIcon: Icon(Icons.account_circle_rounded, size: m.icon(23)),
            label: 'Profil',
          ),
        ],
        ),
      ),
    );
  }
}
