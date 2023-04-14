import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_shop/providers/products_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../providers/cart.dart';

import 'package:web_shop/screens/cart_screen.dart';

import '../widgets/drawer.dart';
import '../widgets/badge.dart' as my_badge;
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
            'https://assets.allegrostatic.com/seller-extras-c1/shop-cover_102853286_5ac3aa0b-101d-4c30-b3dd-f0cc271799f4'),
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.more_horiz),
              itemBuilder: (_) {
                return [
                  const PopupMenuItem(
                    value: filterOptions.Favorites,
                    child: Text('Tylko ulubione'),
                  ),
                  const PopupMenuItem(
                    value: filterOptions.All,
                    child: Text('Pokaż wszystko'),
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
            builder: (_, cart, ch) => my_badge.Badge(
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
      drawer: const SafeArea(
        child: DrawerApp(),
      ),
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.inkDrop(
                  color: Theme.of(context).colorScheme.secondary, size: 40),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
