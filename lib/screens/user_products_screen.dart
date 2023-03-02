import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';

import '../widgets/drawer.dart';
import '../widgets/user_product.dart';

import '../providers/products_provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      drawer: const DrawerApp(),
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: ListView.builder(
          itemCount: productsData.products.length,
          itemBuilder: (ctx, i) => UserProduct(
            id: productsData.products[i].id,
            title: productsData.products[i].title,
            imageUrl: productsData.products[i].imageUrl,
            removeProduct: productsData.products[i],
          ),
        ),
      ),
    );
  }
}
