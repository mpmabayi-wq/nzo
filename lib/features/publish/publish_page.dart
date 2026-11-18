import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/state/app_state.dart';
import '../../core/utils/metrics.dart';
import '../../data/property.dart';
import '../../widgets/common.dart';
import '../../widgets/pill.dart';
import '../../widgets/page_sliver_header.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({super.key, required this.onPublished});

  final VoidCallback onPublished;

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _price = TextEditingController();
  final _quartier = TextEditingController();
  final _description = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();

  String _offer = 'Location';
  String _type = kTypes.first;
  String _commune = kCommunes.first;
  String _role = kRoles.first;
  int _bedrooms = 1;

  @override
  void dispose() {
    for (final c in [_title, _price, _quartier, _description, _name, _phone]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Ce champ est obligatoire' : null;

  String? _priceRule(String? v) {
    if (v == null || v.trim().isEmpty) return 'Indiquez un prix';
    final n = double.tryParse(v.trim().replaceAll(',', '.'));
    if (n == null || n <= 0) return 'Prix invalide';
    return null;
  }

  String? _phoneRule(String? v) {
    if (v == null || v.trim().isEmpty) return 'Indiquez votre numéro';
    final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 9) return 'Numéro trop court';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final state = AppScope.of(context);
    state.addProperty(Property(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _title.text.trim(),
      type: _type,
      offer: _offer,
      price: double.tryParse(_price.text.trim().replaceAll(',', '.')) ?? 0,
      commune: _commune,
      quartier: _quartier.text.trim(),
      bedrooms: _type == 'Parcelle' || _type == 'Local commercial' ? 0 : _bedrooms,
      description: _description.text.trim().isEmpty
          ? 'Aucune description.'
          : _description.text.trim(),
      contactName: _name.text.trim(),
      contactRole: _role,
      phone: _phone.text.trim(),
    ));
    for (final c in [_title, _price, _quartier, _description]) {
      c.clear();
    }
    FocusScope.of(context).unfocus();

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        final m = ctx.m;
        final scheme = Theme.of(ctx).colorScheme;
        final text = Theme.of(ctx).textTheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(m.s(28))),
          backgroundColor: scheme.surfaceContainerLow,
          surfaceTintColor: Colors.transparent,
          contentPadding: EdgeInsets.all(m.s(24)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(m.s(16)),
                decoration: const BoxDecoration(
                  color: Color(0xFFD9F5E8),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_rounded,
                    size: m.icon(40), color: const Color(0xFF1FA971)),
              ),
              SizedBox(height: m.s(18)),
              Text('Annonce publiée !', style: text.titleLarge, textAlign: TextAlign.center),
              SizedBox(height: m.s(8)),
              Text(
                'Votre bien est maintenant visible par les personnes qui cherchent.',
                textAlign: TextAlign.center,
                style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
              SizedBox(height: m.s(22)),
              FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Voir les annonces'),
              ),
            ],
          ),
        );
      },
    );
    widget.onPublished();
  }

  @override
  Widget build(BuildContext context) {
    final m = context.m;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final landOrShop = _type == 'Parcelle' || _type == 'Local commercial';

    Widget label(String t) => Padding(
          padding: EdgeInsets.only(bottom: m.s(8), top: m.s(4)),
          child: Text(t,
              style: text.labelLarge?.copyWith(color: scheme.onSurfaceVariant)),
        );

    Widget card(IconData icon, String title, List<Widget> children) => SoftCard(
          margin: EdgeInsets.only(bottom: m.s(16)),
          padding: EdgeInsets.all(m.s(18)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(m.s(8)),
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(m.s(12)),
                    ),
                    child: Icon(icon, size: m.icon(20), color: scheme.primary),
                  ),
                  SizedBox(width: m.s(12)),
                  Expanded(child: Text(title, style: text.titleMedium)),
                ],
              ),
              SizedBox(height: m.s(16)),
              ...children,
            ],
          ),
        );

    Widget wrapPills(List<Widget> pills) =>
        Wrap(spacing: m.s(8), runSpacing: m.s(8), children: pills);

    return Form(
      key: _formKey,
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          const NzoSliverHeader(title: 'Publier un bien', eyebrow: 'PARTAGER UNE ANNONCE', subtitle: 'Présentez votre bien simplement et clairement.'),
          SliverToBoxAdapter(child: Padding(
            padding: EdgeInsets.only(bottom: m.s(28)),
            child: Padding(
              padding: m.pageH,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                card(Icons.sell_rounded, 'Type d\'annonce', [
                  SegmentedButton<String>(
                    showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(
                      minimumSize: Size.fromHeight(m.fit(48)),
                    ),
                    segments: [
                      for (final o in kOffers) ButtonSegment(value: o, label: Text(o)),
                    ],
                    selected: {_offer},
                    onSelectionChanged: (s) => setState(() => _offer = s.first),
                  ),
                ]),
                card(Icons.home_work_rounded, 'Le bien', [
                  label('Type de bien'),
                  wrapPills([
                    for (final t in kTypes)
                      Pill(
                        label: t,
                        icon: iconForType(t),
                        selected: _type == t,
                        onTap: () => setState(() => _type = t),
                      ),
                  ]),
                  SizedBox(height: m.s(16)),
                  TextFormField(
                    controller: _title,
                    validator: _required,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Titre de l\'annonce',
                      hintText: 'Ex. Maison 3 chambres avec cour',
                    ),
                  ),
                  SizedBox(height: m.s(14)),
                  TextFormField(
                    controller: _price,
                    validator: _priceRule,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                    decoration: InputDecoration(
                      labelText: _offer == 'Location' ? 'Prix par mois' : 'Prix',
                      suffixText: 'USD',
                    ),
                  ),
                  if (!landOrShop) ...[
                    SizedBox(height: m.s(16)),
                    Row(
                      children: [
                        Expanded(child: Text('Chambres', style: text.titleSmall)),
                        IconButton.filledTonal(
                          tooltip: 'Moins',
                          onPressed: _bedrooms > 0 ? () => setState(() => _bedrooms--) : null,
                          icon: Icon(Icons.remove_rounded, size: m.icon(22)),
                        ),
                        SizedBox(
                          width: m.s(44),
                          child: Text('$_bedrooms',
                              textAlign: TextAlign.center, style: text.titleLarge),
                        ),
                        IconButton.filledTonal(
                          tooltip: 'Plus',
                          onPressed: () => setState(() => _bedrooms++),
                          icon: Icon(Icons.add_rounded, size: m.icon(22)),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: m.s(14)),
                  TextFormField(
                    controller: _description,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Description (facultatif)',
                      alignLabelWithHint: true,
                    ),
                  ),
                ]),
                card(Icons.location_on_rounded, 'Localisation', [
                  label('Commune'),
                  wrapPills([
                    for (final c in kCommunes)
                      Pill(label: c, selected: _commune == c, onTap: () => setState(() => _commune = c)),
                  ]),
                  SizedBox(height: m.s(16)),
                  TextFormField(
                    controller: _quartier,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Quartier ou repère',
                      hintText: 'Ex. près du marché',
                    ),
                  ),
                ]),
                card(Icons.person_rounded, 'Vos coordonnées', [
                  label('Vous êtes'),
                  wrapPills([
                    for (final r in kRoles)
                      Pill(label: r, selected: _role == r, onTap: () => setState(() => _role = r)),
                  ]),
                  SizedBox(height: m.s(16)),
                  TextFormField(
                    controller: _name,
                    validator: _required,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(labelText: 'Votre nom'),
                  ),
                  SizedBox(height: m.s(14)),
                  TextFormField(
                    controller: _phone,
                    validator: _phoneRule,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]'))],
                    decoration: const InputDecoration(
                      labelText: 'Téléphone / WhatsApp',
                      hintText: '+243 …',
                    ),
                  ),
                ]),
                SizedBox(height: m.s(4)),
                FilledButton.icon(
                  onPressed: _submit,
                  icon: Icon(Icons.rocket_launch_rounded, size: m.icon(22)),
                  label: const Text('Publier mon annonce'),
                ),
              ],
            ),
          ))),
        ],
      ),
    );
  }
}
