import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../data/property.dart';

/// Demande de recherche envoyée depuis l'accueil vers l'onglet « Chercher ».
class SearchRequest {
  final String? offer; // Location / Vente / null = tous
  final String? type; // type de bien / null = tous
  const SearchRequest({this.offer, this.type});
}

class AppState extends ChangeNotifier {
  /// Par défaut, l'appli suit le mode clair / sombre de l'appareil.
  ThemeMode themeMode = ThemeMode.system;
  int themeIndex = 0;

  bool loggedIn = false;
  String userName = '';
  String loginProvider = '';

  final List<Property> properties = List.of(mockProperties);
  final Set<String> favoriteIds = {};

  void setTheme(int index) {
    final safe = index.clamp(0, 1).toInt();
    if (safe == themeIndex) return;
    themeIndex = safe;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (mode == themeMode) return;
    themeMode = mode;
    notifyListeners();
  }

  void login(String provider) {
    loggedIn = true;
    loginProvider = provider;
    userName = 'Utilisateur $provider';
    notifyListeners();
  }

  void logout() {
    loggedIn = false;
    userName = '';
    loginProvider = '';
    notifyListeners();
  }

  bool isFavorite(String id) => favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (!favoriteIds.remove(id)) favoriteIds.add(id);
    notifyListeners();
  }

  void addProperty(Property p) {
    properties.insert(0, p);
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState super.notifier, required super.child});

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope introuvable');
    return scope!.notifier!;
  }
}
