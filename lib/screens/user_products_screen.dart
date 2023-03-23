import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../screens/edit_product_screen.dart';

import '../widgets/drawer.dart';
import '../widgets/user_product.dart';

import '../providers/products_provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndAddproducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      drawer: const DrawerApp(),
      appBar: AppBar(
        title: const Text('Twoje produkty'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: LoadingAnimationWidget.inkDrop(
                        color: Theme.of(context).colorScheme.secondary,
                        size: 40),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<ProductsProvider>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: const EdgeInsets.all(5),
                        child: ListView.builder(
                          itemCount: productsData.products.length,
                          itemBuilder: (ctx, i) => UserProduct(
                            id: productsData.products[i]!.id,
                            title: productsData.products[i]!.title,
                            imageUrl: productsData.products[i]!.imageUrl,
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
