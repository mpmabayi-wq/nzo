import 'property.dart';

const _accents = {
  'à': 'a', 'â': 'a', 'ä': 'a', 'á': 'a', 'ã': 'a', 'å': 'a',
  'ç': 'c',
  'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
  'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
  'ñ': 'n',
  'ó': 'o', 'ò': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o', 'œ': 'o',
  'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
  'ý': 'y', 'ÿ': 'y',
};

/// Minuscules + sans accents, pour comparer facilement.
String normalize(String input) {
  final b = StringBuffer();
  for (final ch in input.toLowerCase().split('')) {
    b.write(_accents[ch] ?? ch);
  }
  return b.toString();
}

const _typeWords = {
  'Maison': 'maison villa',
  'Appartement': 'appartement appart',
  'Chambre / Studio': 'chambre studio',
  'Parcelle': 'parcelle terrain',
  'Local commercial': 'local commercial boutique magasin commerce',
};

/// Critères d'une recherche (aussi utilisés pour l'historique).
class SearchCriteria {
  final String query;
  final String? offer; // Location / Vente / null
  final String? type;
  final String? commune;

  const SearchCriteria({this.query = '', this.offer, this.type, this.commune});

  bool get isEmpty =>
      query.trim().isEmpty && offer == null && type == null && commune == null;

  String get summary {
    final parts = <String>[
      if (offer != null) offerLabel(offer!),
      if (type != null) type!,
      if (commune != null) commune!,
    ];
    return parts.join(' · ');
  }

  String get title => query.trim().isNotEmpty ? query.trim() : summary;
  String get subtitle => query.trim().isEmpty ? '' : summary;

  bool sameAs(SearchCriteria o) =>
      normalize(query.trim()) == normalize(o.query.trim()) &&
      offer == o.offer &&
      type == o.type &&
      commune == o.commune;

  Map<String, dynamic> toJson() => {'q': query, 'o': offer, 't': type, 'c': commune};

  factory SearchCriteria.fromJson(Map<String, dynamic> j) => SearchCriteria(
        query: (j['q'] as String?) ?? '',
        offer: j['o'] as String?,
        type: j['t'] as String?,
        commune: j['c'] as String?,
      );
}

String _searchableText(Property p) {
  final offerWords = p.isRental ? 'location louer a louer loyer' : 'vente acheter a vendre achat';
  return normalize(
    '${p.title} ${p.description} ${p.type} ${_typeWords[p.type] ?? ''} '
    '${p.commune} ${p.quartier} $offerWords',
  );
}

final _numeric = RegExp(r'^\d+([.,]\d+)?$');

List<String> _tokens(String query) => normalize(query)
    .split(RegExp(r'\s+'))
    .where((t) => t.isNotEmpty)
    .toList();

/// Un mot de la recherche correspond-il au bien ?
/// - un petit nombre (moins de 10) = nombre de chambres
/// - un grand nombre = budget maximum (prix ≤ nombre)
/// - sinon, le mot doit apparaître dans le titre, la description, le type...
bool _tokenMatches(Property p, String hay, String token) {
  if (_numeric.hasMatch(token)) {
    final v = double.tryParse(token.replaceAll(',', '.'));
    if (v == null) return false;
    if (v < 10) return p.bedrooms == v.round();
    return p.price <= v;
  }
  if (hay.contains(token)) return true;
  if (token.length > 3 && token.endsWith('s') && hay.contains(token.substring(0, token.length - 1))) {
    return true;
  }
  return false;
}

bool matchesCriteria(Property p, SearchCriteria c) {
  if (c.offer != null && p.offer != c.offer) return false;
  if (c.type != null && p.type != c.type) return false;
  if (c.commune != null && p.commune != c.commune) return false;
  final tokens = _tokens(c.query);
  if (tokens.isEmpty) return true;
  final hay = _searchableText(p);
  return tokens.every((t) => _tokenMatches(p, hay, t));
}

List<Property> searchProperties(List<Property> all, SearchCriteria c) =>
    [for (final p in all) if (matchesCriteria(p, c)) p];

/// Biens proches des recherches récentes de l'utilisateur (les plus récentes
/// comptent davantage).
List<Property> recommend(List<Property> all, List<SearchCriteria> history, {int limit = 8}) {
  if (history.isEmpty || all.isEmpty) return const [];
  final scores = List<double>.filled(all.length, 0);

  for (var i = 0; i < history.length; i++) {
    final h = history[i];
    final weight = 1.0 / (1 + i * 0.5);
    final tokens = _tokens(h.query);
    for (var j = 0; j < all.length; j++) {
      final p = all[j];
      var s = 0.0;
      if (h.type != null && p.type == h.type) s += 3;
      if (h.offer != null && p.offer == h.offer) s += 2;
      if (h.commune != null && p.commune == h.commune) s += 1.5;
      if (tokens.isNotEmpty) {
        final hay = _searchableText(p);
        final hits = tokens.where((t) => _tokenMatches(p, hay, t)).length;
        s += 3.0 * hits / tokens.length;
      }
      scores[j] += s * weight;
    }
  }

  final idx = [for (var j = 0; j < all.length; j++) if (scores[j] > 0) j];
  idx.sort((a, b) {
    final c = scores[b].compareTo(scores[a]);
    return c != 0 ? c : a.compareTo(b);
  });
  return [for (final j in idx.take(limit)) all[j]];
}
