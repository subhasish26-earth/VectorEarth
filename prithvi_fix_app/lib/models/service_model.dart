import '../core/constants/app_images.dart';
import '../core/constants/service_translations.dart';

/// Trade category representation
class ServiceCategory {
  final String id;
  final String name;
  final ImageAssetInfo imageInfo;
  final int serviceCount;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.imageInfo,
    required this.serviceCount,
  });
}

/// Service Item representation for all 47 services
class ServiceItem {
  final int id;
  final String name;
  final String category;
  final String description;
  final double basePrice;
  final String priceUnit;
  final int durationMinutes;
  final bool isComplex;
  final ImageAssetInfo imageInfo;
  final double rating;
  final int reviewCount;
  final List<String> included;
  final List<String> excluded;

  const ServiceItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.basePrice,
    this.priceUnit = 'per_unit',
    this.durationMinutes = 45,
    this.isComplex = false,
    required this.imageInfo,
    this.rating = 4.85,
    this.reviewCount = 1240,
    this.included = const [],
    this.excluded = const [],
  });

  /// Localized service display name
  String get localizedName => ServiceNameTranslations.translate(name);

  String get formattedPrice {
    final priceStr = basePrice.toStringAsFixed(basePrice.truncateToDouble() == basePrice ? 0 : 2);
    if (priceUnit == 'per_sqft') {
      return '₹$priceStr / sq.ft';
    } else if (priceUnit == 'per_day') {
      return '₹$priceStr / day';
    } else if (priceUnit == 'per_visit') {
      return '₹$priceStr / visit';
    } else if (priceUnit == 'per_point') {
      return '₹$priceStr / point';
    } else {
      return '₹$priceStr';
    }
  }
}

/// Cart item holding service & selected quantity
class CartItem {
  final ServiceItem service;
  int quantity;

  CartItem({
    required this.service,
    this.quantity = 1,
  });

  double get totalPrice => service.basePrice * quantity;
}
