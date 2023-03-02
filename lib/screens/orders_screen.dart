import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your orders'),
      ),
      drawer: const DrawerApp(),
      body: orderData.orderedProducts.isEmpty
          ? const Center(
              child: Text(
                'No orders placed yet.',
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: orderData.orderedProducts.length,
              itemBuilder: (context, i) =>
                  OrderItem(orderData.orderedProducts[i]),
            ),
    );
  }
}
