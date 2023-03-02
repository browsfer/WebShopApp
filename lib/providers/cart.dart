import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem(
      {required this.id,
      required this.productId,
      required this.title,
      required this.price,
      required this.quantity});
}

class Cart with ChangeNotifier {
  late Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  double get totalPrice {
    var total = 0.0;
    _items.forEach(
      (key, cartItem) {
        total += cartItem.price * cartItem.quantity;
      },
    );
    return total;
  }

  int get countCart {
    return _items.length;
  }

  void addItem(String? productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId!,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            productId: existingCartItem.productId,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        productId!,
        () => CartItem(
          id: DateTime.now().toString(),
          productId: productId,
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String? productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId!,
        (existingCartItem) => CartItem(
          id: DateTime.now().toString(),
          productId: productId,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
