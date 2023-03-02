import 'package:flutter/material.dart';

import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';

class DrawerApp extends StatelessWidget {
  const DrawerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(25),
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: const Text(
              'My Web Shop',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text(
              'Shop',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text(
              'My orders',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text(
              'My products',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
