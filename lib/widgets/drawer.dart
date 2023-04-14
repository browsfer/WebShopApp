import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

import '../helpers/custom_route.dart';
import '../providers/auth.dart';

import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/product_overview_screen.dart';

class DrawerApp extends StatefulWidget {
  const DrawerApp({super.key});

  @override
  State<DrawerApp> createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    TextEditingController textController = TextEditingController();

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Stack(
              fit: StackFit.loose,
              children: [
                Image.network(
                    'https://assets.allegrostatic.com/seller-extras-c1/shop-cover_102853286_5ac3aa0b-101d-4c30-b3dd-f0cc271799f4'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: AnimSearchBar(
                      width: 400,
                      textController: textController,
                      onSuffixTap: () {
                        setState(() {
                          textController.clear();
                        });
                      },
                      onSubmitted: (_) {},
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text(
              'Sklep',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  CustomRoute(builder: (ctx) => ProductOverviewScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text(
              'Moje zamówienia',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  CustomRoute(builder: (ctx) => OrdersScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text(
              'Moje produkty',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          const Divider(),
          const Spacer(),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
            child: const Text('WYLOGUJ'),
          ),
        ],
      ),
    );
  }
}
