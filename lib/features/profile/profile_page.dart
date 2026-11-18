import 'package:flutter/material.dart';
import '../../app.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_themes.dart';
import '../../core/utils/metrics.dart';
import '../../widgets/common.dart';
import '../../widgets/nzo_logo.dart';
import '../../widgets/theme_mode_selector.dart';
import '../../widgets/theme_selector.dart';
import '../../widgets/page_sliver_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final state = AppScope.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final dark = scheme.brightness == Brightness.dark;

    Widget infoRow(IconData icon, String label, String value) => Padding(
          padding: EdgeInsets.symmetric(vertical: m.s(8)),
          child: Row(
            children: [
              Icon(icon, size: m.icon(22), color: scheme.primary),
              SizedBox(width: m.s(12)),
              Expanded(child: Text(label, style: text.bodyLarge)),
              Text(value, style: text.labelLarge?.copyWith(color: scheme.onSurfaceVariant)),
            ],
          ),
        );

    return CustomScrollView(
      key: const PageStorageKey<String>('nzo-profile-scroll'),
      slivers: [
        const NzoSliverHeader(title: 'Mon espace', eyebrow: 'COMPTE & PRÉFÉRENCES', subtitle: 'Gérez votre expérience Nzo.'),
        SliverToBoxAdapter(child: Padding(
          padding: EdgeInsets.only(bottom: m.s(28)),
          child: Column(children: [

        // Carte identité
        Padding(
          padding: m.pageH,
          child: Container(
            padding: EdgeInsets.all(m.s(18)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(m.s(24)),
              gradient: LinearGradient(
                colors: dark
                    ? const [Color(0xFF0F4A82), Color(0xFF071A2E)]
                    : const [AppColors.brandLight, AppColors.brandDeep],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                NzoLogo(height: m.s(58), style: NzoLogoStyle.light),
                SizedBox(width: m.s(16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.userName.isEmpty ? 'Invité' : state.userName,
                        style: text.titleLarge?.copyWith(color: Colors.white),
                      ),
                      SizedBox(height: m.s(4)),
                      Text(
                        state.loginProvider.isEmpty
                            ? 'Non connecté'
                            : 'Connecté avec ${state.loginProvider}',
                        style: text.bodyMedium
                            ?.copyWith(color: Colors.white.withValues(alpha: 0.85)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: m.s(24)),

        // Apparence
        Padding(padding: m.pageH, child: const SectionHeader(title: 'Apparence')),
        SizedBox(height: m.s(8)),
        Padding(
          padding: m.pageH,
          child: SoftCard(
            padding: EdgeInsets.all(m.s(16)),
            child: const ThemeModeCards(),
          ),
        ),
        SizedBox(height: m.s(18)),
        Padding(padding: m.pageH, child: const SectionHeader(title: 'Identité visuelle')),
        SizedBox(height: m.s(8)),
        Padding(padding: m.pageH, child: SoftCard(padding: EdgeInsets.all(m.s(14)), child: const ThemeSelector())),
        SizedBox(height: m.s(24)),

        // Affichage (réglages de l'appareil)
        Padding(padding: m.pageH, child: const SectionHeader(title: 'Affichage')),
        SizedBox(height: m.s(8)),
        Padding(
          padding: m.pageH,
          child: SoftCard(
            padding: EdgeInsets.symmetric(horizontal: m.s(16), vertical: m.s(8)),
            child: Column(
              children: [
                infoRow(Icons.text_fields_rounded, 'Taille du texte',
                    '${(m.textScale * 100).round()} %'),
                const Divider(),
                infoRow(Icons.palette_rounded, 'Mode actuel', dark ? 'Sombre' : 'Clair'),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(m.s(24), m.s(10), m.s(24), 0),
          child: Text(
            'La taille du texte et des icônes suit les réglages de votre téléphone.',
            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ),
        SizedBox(height: m.s(28)),

        Padding(
          padding: m.pageH,
          child: OutlinedButton.icon(
            onPressed: () {
              state.logout();
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: scheme.error,
              side: BorderSide(color: scheme.error.withValues(alpha: 0.5), width: 1.4),
            ),
            icon: Icon(Icons.logout_rounded, size: m.icon(22)),
            label: const Text('Se déconnecter'),
          ),
        ),
          ]),
        )),
      ],
    );
  }
}
