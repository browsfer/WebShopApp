import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_shop/providers/products_provider.dart';

import '../providers/cart.dart';

import 'package:web_shop/screens/cart_screen.dart';

import '../widgets/drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

enum filterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    if (_isInit) {
      _isLoading = true;
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndAddproducts()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    // if (_isInit) {
    //   Future.delayed(Duration.zero).then(
    //     (value) => Provider.of<ProductsProvider>(context, listen: false)
    //         .fetchAndAddproducts(),
    //   );
    //   _isInit = false;
    // }

    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   setState(() {
  //     _isInit = true;
  //   });
  //   if (_isInit) {
  //     Provider.of<ProductsProvider>(context)
  //         .fetchAndAddproducts()
  //         .then((_) => setState(() {
  //               _isInit = false;
  //             }));
  //   }

  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    // final _products = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Web Shop'),
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.more_horiz),
              itemBuilder: (_) {
                return [
                  const PopupMenuItem(
                    value: filterOptions.Favorites,
                    child: Text('Only favorites'),
                  ),
                  const PopupMenuItem(
                    value: filterOptions.All,
                    child: Text('Show all'),
                  )
                ];
              },
              onSelected: (filterOptions selectedValue) {
                setState(() {
                  if (selectedValue == filterOptions.All) {
                    _showOnlyFavorites = false;
                  } else {
                    _showOnlyFavorites = true;
                  }
                });
              }),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              value: cart.countCart.toString(),
              color: Theme.of(context).colorScheme.secondary,
              child: ch!,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: const DrawerApp(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
