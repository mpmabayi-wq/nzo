import 'package:flutter/material.dart';

const kOffers = ['Location', 'Vente'];
const kTypes = ['Maison', 'Appartement', 'Chambre / Studio', 'Parcelle', 'Local commercial'];
const kCommunes = ['Matadi', 'Mvuzi', 'Nzanza'];
const kRoles = ['Commissionnaire', 'Propriétaire'];

IconData iconForType(String type) {
  switch (type) {
    case 'Maison':
      return Icons.home_rounded;
    case 'Appartement':
      return Icons.apartment_rounded;
    case 'Chambre / Studio':
      return Icons.bed_rounded;
    case 'Parcelle':
      return Icons.landscape_rounded;
    case 'Local commercial':
      return Icons.storefront_rounded;
  }
  return Icons.house_rounded;
}

String groupDigits(num value) {
  final s = value.round().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('\u202F');
    b.write(s[i]);
  }
  return b.toString();
}

class Property {
  final String id;
  final String title;
  final String type;
  final String offer; // Location ou Vente
  final double price; // en USD
  final String commune;
  final String quartier;
  final int bedrooms;
  final String description;
  final String contactName;
  final String contactRole;
  final String phone;

  const Property({
    required this.id,
    required this.title,
    required this.type,
    required this.offer,
    required this.price,
    required this.commune,
    required this.quartier,
    required this.bedrooms,
    required this.description,
    required this.contactName,
    required this.contactRole,
    required this.phone,
  });

  bool get isRental => offer == 'Location';

  String get priceText => '${groupDigits(price)} \$';
  String get priceUnit => isRental ? '/ mois' : '';

  String get placeLabel => quartier.isEmpty ? commune : '$quartier, $commune';
}
