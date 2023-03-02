import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/products_provider.dart';

import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showFavOnly;

  ProductsGrid(this._showFavOnly);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products =
        _showFavOnly ? productsData.onlyFavorite : productsData.products;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2 / 2.5,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
            // id: products[i].id,
            // title: products[i].title,
            // imageUrl: products[i].imageUrl,
            // price: products[i].price),
            ),
      ),
      itemCount: products.length,
    );
  }
}
