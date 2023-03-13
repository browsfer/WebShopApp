import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> orders;
  final DateTime date;

  OrderItem({
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

  Future<void> fetchAndAddproducts() async {
    final response = await http.get(Uri.parse(
        'https://fluttercourse-4800b-default-rtdb.europe-west1.firebasedatabase.app/orders.json'));

    List<OrderItem> loadedOrders = [];

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData.isEmpty) {
      return;
    }
    extractedData.forEach(
      (orderId, orderValue) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderValue['amount'],
            date: DateTime.parse(orderValue['dateTime']),
            orders: (orderValue['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    productId: item['id'],
                    title: item['title'],
                    price: item['price'],
                    quantity: item['quantity'],
                  ),
                )
                .toList(),
          ),
        );
      },
    );

    _orderedProducts = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(
      List<CartItem> cartProducts, double total, String title) async {
    final timestamp = DateTime.now();
    try {
      final orderResponse = await http.post(
        Uri.parse(
            'https://fluttercourse-4800b-default-rtdb.europe-west1.firebasedatabase.app/orders.json'),
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.productId,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }),
      );
      _orderedProducts.insert(
        0,
        OrderItem(
          id: json.decode(orderResponse.body)['name'],
          amount: total,
          orders: cartProducts,
          date: timestamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
