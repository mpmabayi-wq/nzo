import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_themes.dart';
import '../../core/utils/metrics.dart';
import '../../widgets/nzo_logo.dart';
import '../../widgets/theme_mode_selector.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;

  Future<void> _signIn(String provider) async {
    setState(() => _loading = true);
    // Simulation : la vraie connexion Google / Apple sera branchée plus tard.
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    AppScope.of(context).login(provider);
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final dark = scheme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: scheme.surface,
        systemNavigationBarIconBrightness: dark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (context, c) {
                final heroHeight = math.max(m.fit(330), c.maxHeight * 0.46);
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _Hero(height: heroHeight, dark: dark),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                m.s(24), m.s(28), m.s(24), m.s(24) + m.safe.bottom),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text('Bienvenue', style: text.headlineSmall),
                                SizedBox(height: m.s(6)),
                                Text(
                                  'Connectez-vous pour publier un bien, enregistrer vos favoris et contacter directement.',
                                  style: text.bodyMedium
                                      ?.copyWith(color: scheme.onSurfaceVariant),
                                ),
                                SizedBox(height: m.s(24)),
                                if (_loading)
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: m.s(34)),
                                    child: Center(
                                      child: SizedBox(
                                        width: m.s(34),
                                        height: m.s(34),
                                        child: const CircularProgressIndicator(strokeWidth: 3.5),
                                      ),
                                    ),
                                  )
                                else ...[
                                  _SocialButton(
                                    label: 'Continuer avec Google',
                                    leading: const _GoogleG(),
                                    background: scheme.surfaceContainerLow,
                                    foreground: scheme.onSurface,
                                    borderColor: scheme.outlineVariant,
                                    onTap: () => _signIn('Google'),
                                  ),
                                  SizedBox(height: m.s(12)),
                                  _SocialButton(
                                    label: 'Continuer avec Apple',
                                    leading: Icon(Icons.apple,
                                        size: m.icon(26), color: scheme.surface),
                                    background: scheme.onSurface,
                                    foreground: scheme.surface,
                                    onTap: () => _signIn('Apple'),
                                  ),
                                ],
                                SizedBox(height: m.s(30)),
                                const _Benefits(),
                                SizedBox(height: m.s(26)),
                                Text(
                                  'En continuant, vous acceptez les conditions d\'utilisation et la politique de confidentialité de Nzo.',
                                  textAlign: TextAlign.center,
                                  style: text.bodySmall
                                      ?.copyWith(color: scheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Choix du thème : coin haut droit
            Positioned(
              top: m.safe.top + m.s(8),
              right: m.s(14),
              child: const ThemeModeButton(onHero: true),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.height, required this.dark});

  final double height;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final text = Theme.of(context).textTheme;
    final colors = dark
        ? const [Color(0xFF0F4A82), Color(0xFF071A2E)]
        : const [AppColors.brandLight, AppColors.brandDeep];

    return Container(
      height: height,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(m.s(40))),
      ),
      child: Stack(
        children: [
          Positioned(right: -m.s(70), top: -m.s(50), child: _Circle(m.s(240), 0.08)),
          Positioned(left: -m.s(90), bottom: -m.s(110), child: _Circle(m.s(280), 0.07)),
          Positioned(right: m.s(40), bottom: m.s(46), child: _Circle(m.s(34), 0.14)),
          Padding(
            padding: EdgeInsets.fromLTRB(m.s(28), m.safe.top + m.s(24), m.s(28), m.s(24)),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NzoLogo(height: m.s(74), withWord: true, style: NzoLogoStyle.light),
                  SizedBox(height: m.s(26)),
                  Text(
                    'Trouvez votre chez-vous à Matadi',
                    textAlign: TextAlign.center,
                    style: text.headlineSmall?.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: m.s(10)),
                  Text(
                    'Louez, achetez ou publiez un bien\nen toute simplicité.',
                    textAlign: TextAlign.center,
                    style: text.bodyLarge
                        ?.copyWith(color: Colors.white.withValues(alpha: 0.86)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle(this.size, this.alpha);
  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: alpha),
        ),
      );
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.leading,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.borderColor,
  });

  final String label;
  final Widget leading;
  final Color background;
  final Color foreground;
  final Color? borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final text = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(m.s(18));
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: background,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(minHeight: m.fit(58)),
            padding: EdgeInsets.symmetric(horizontal: m.s(18), vertical: m.s(10)),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: borderColor == null ? null : Border.all(color: borderColor!, width: 1.4),
            ),
            child: Row(
              children: [
                SizedBox(width: m.icon(28), child: Center(child: leading)),
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: text.titleSmall?.copyWith(color: foreground, fontSize: 16),
                  ),
                ),
                SizedBox(width: m.icon(28)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// « G » multicolore façon Google, sans image.
class _GoogleG extends StatelessWidget {
  const _GoogleG();

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (rect) => const SweepGradient(
        colors: [
          Color(0xFF4285F4),
          Color(0xFF34A853),
          Color(0xFFFBBC05),
          Color(0xFFEA4335),
          Color(0xFF4285F4),
        ],
        stops: [0.0, 0.30, 0.52, 0.78, 1.0],
      ).createShader(rect),
      child: Text(
        'G',
        style: TextStyle(
          fontSize: m.icon(26),
          fontWeight: FontWeight.w900,
          color: Colors.white,
          height: 1.0,
        ),
      ),
    );
  }
}

class _Benefits extends StatelessWidget {
  const _Benefits();

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    Widget item(IconData icon, String label) => Expanded(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(m.s(12)),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: m.icon(24), color: scheme.primary),
              ),
              SizedBox(height: m.s(8)),
              Text(label,
                  textAlign: TextAlign.center,
                  style: text.labelMedium?.copyWith(color: scheme.onSurface)),
            ],
          ),
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        item(Icons.search_rounded, 'Recherche\nfacile'),
        item(Icons.bolt_rounded, 'Publication\nrapide'),
        item(Icons.call_rounded, 'Contact\ndirect'),
      ],
    );
  }
}
