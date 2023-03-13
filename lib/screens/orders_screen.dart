import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders-screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Orders>(context, listen: false).fetchAndAddproducts();
  }

  var isLoading = false;

  @override
  void initState() {
    isLoading = true;

    Provider.of<Orders>(context, listen: false).fetchAndAddproducts().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your orders'),
      ),
      drawer: const DrawerApp(),
      body: (orderData.orderedProducts.isEmpty)
          ? RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: const Center(
                child: Text(
                  'No orders placed yet.',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          : isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => _refreshProducts(context),
                  child: ListView.builder(
                    itemCount: orderData.orderedProducts.length,
                    itemBuilder: (context, i) =>
                        OrderItem(orderData.orderedProducts[i]),
                  ),
                ),
    );
  }
}
