import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_shop/screens/orders_screen.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    var isLoading = false;
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mój koszyk'),
      ),
      body: Column(
        children: [
          Card(
            elevation: 7,
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'W sumie:',
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
                      '${cart.totalPrice.toStringAsFixed(2)}zł',
                      style: Theme.of(context).primaryTextTheme.titleSmall,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  const Spacer(),
                  TextButton(
                    style: ButtonStyle(
                      shadowColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.secondary),
                      foregroundColor: MaterialStatePropertyAll(
                          Theme.of(context).primaryColor),
                    ),
                    onPressed: (cart.totalPrice <= 0 || isLoading)
                        ? null
                        : () async {
                            setState(() {
                              isLoading = true;
                            });

                            await Provider.of<Orders>(context, listen: false)
                                .addOrder(
                              cart.items.values.toList(),
                              cart.totalPrice,
                              cart.items.values.first.title,
                            );
                            setState(() {
                              isLoading = false;
                            });
                            cart.clearCart();
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 6),
                                content: const Text('Złożyłeś zamówienie.'),
                                action: SnackBarAction(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(OrdersScreen.routeName);
                                  },
                                  label: 'Pokaż',
                                ),
                              ),
                            );
                          },
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text('ZŁÓŻ ZAMÓWIENIE'),
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
