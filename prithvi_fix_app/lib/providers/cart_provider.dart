import 'package:flutter/foundation.dart';
import '../models/service_model.dart';

/// Global Cart & Escrow State Provider
/// Tracks active selected services and dynamically computes the 93-2-5 Escrow breakdown.
class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => {..._items};

  int get totalItemCount {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  int get totalQuantity => totalItemCount;
  List<CartItem> get itemList => _items.values.toList();

  bool get isEmpty => _items.isEmpty;

  int getQuantity(int serviceId) {
    return _items[serviceId]?.quantity ?? 0;
  }

  double get subtotal {
    return _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // 93-2-5 Statutory Escrow Split (Rounded to exact 2 decimals)
  double get welfareFund5 => ((subtotal * 0.05 * 100).roundToDouble() / 100);
  double get platformUpkeep2 => ((subtotal * 0.02 * 100).roundToDouble() / 100);
  double get workerDirectWage93 => ((subtotal - welfareFund5 - platformUpkeep2) * 100).roundToDouble() / 100;

  void addService(ServiceItem service) {
    if (_items.containsKey(service.id)) {
      _items[service.id]!.quantity += 1;
    } else {
      _items[service.id] = CartItem(service: service, quantity: 1);
    }
    notifyListeners();
  }

  void removeService(ServiceItem service) {
    if (!_items.containsKey(service.id)) return;

    if (_items[service.id]!.quantity > 1) {
      _items[service.id]!.quantity -= 1;
    } else {
      _items.remove(service.id);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void clear() => clearCart();
}
