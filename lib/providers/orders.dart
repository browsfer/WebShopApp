import 'package:flutter/cupertino.dart';

import '../providers/cart.dart';

class OrderItem {
  final String title;
  final String id;
  final double amount;
  final List<CartItem> orders;
  final DateTime date;

  OrderItem({
    required this.title,
    required this.id,
    required this.amount,
    required this.orders,
    required this.date,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orderedProducts = [];

  List<OrderItem> get orderedProducts {
    return [..._orderedProducts];
  }

  void addOrder(List<CartItem> cartProducts, double total, String title) {
    _orderedProducts.insert(
      0,
      OrderItem(
        title: title,
        id: DateTime.now().toString(),
        amount: total,
        orders: cartProducts,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
