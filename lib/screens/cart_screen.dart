import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_shop/screens/orders_screen.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My cart'),
      ),
      body: Column(
        children: [
          Card(
            elevation: 7,
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Chip(
                    label: Text(
                      '\$${cart.totalPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).primaryTextTheme.titleSmall,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(),
                          cart.totalPrice,
                          cart.items.values.first.title);
                      cart.clearCart();
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 6),
                          content: const Text('You have placed an order.'),
                          // backgroundColor: Colors.black,
                          action: SnackBarAction(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(OrdersScreen.routeName);
                            },
                            label: 'Show me my order',
                          ),
                        ),
                      );
                    },
                    child: const Text('PLACE ORDER'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartItem(
                cart.items.values.toList()[i].id,
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
                cart.items.values.toList()[i].productId,
              ),
              itemCount: cart.countCart,
            ),
          ),
        ],
      ),
    );
  }
}
