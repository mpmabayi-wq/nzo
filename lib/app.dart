import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/state/app_state.dart';
import 'core/theme/app_themes.dart';
import 'data/property.dart';
import 'features/auth/login_page.dart';
import 'features/home/main_shell.dart';
import 'features/property/property_detail_page.dart';

class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const property = '/property';
}

class NzoApp extends StatefulWidget {
  const NzoApp({super.key});

  @override
  State<NzoApp> createState() => _NzoAppState();
}

class _NzoAppState extends State<NzoApp> {
  final AppState _state = AppState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      notifier: _state,
      child: Builder(
        builder: (context) {
          final state = AppScope.of(context);
          return MaterialApp(
            title: 'Nzo',
            debugShowCheckedModeBanner: false,
            theme: AppThemes.light(themeIndex: state.themeIndex),
            darkTheme: AppThemes.dark(themeIndex: state.themeIndex),
            themeMode: state.themeMode,
            builder: (context, child) {
              final scheme = Theme.of(context).colorScheme;
              final dark = scheme.brightness == Brightness.dark;
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
                  statusBarBrightness: dark ? Brightness.dark : Brightness.light,
                  systemNavigationBarColor: scheme.surfaceContainerLow,
                  systemNavigationBarIconBrightness:
                      dark ? Brightness.light : Brightness.dark,
                ),
                // Le texte suit le réglage de l'appareil (avec des limites
                // raisonnables pour garder une mise en page propre).
                child: MediaQuery.withClampedTextScaling(
                  minScaleFactor: 0.85,
                  maxScaleFactor: 1.5,
                  child: child!,
                ),
              );
            },
            initialRoute: AppRoutes.login,
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case AppRoutes.login:
                  return MaterialPageRoute(builder: (_) => const LoginPage());
                case AppRoutes.home:
                  return MaterialPageRoute(builder: (_) => const MainShell());
                case AppRoutes.property:
                  final p = settings.arguments as Property;
                  return MaterialPageRoute(
                      builder: (_) => PropertyDetailPage(property: p));
              }
              return MaterialPageRoute(builder: (_) => const LoginPage());
            },
          );
        },
      ),
    );
  }
}
