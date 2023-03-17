import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/providers/cart.dart';
import '/providers/product.dart';
import '/providers/auth.dart';

import '/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // final double price;

//   const ProductItem(
//       {required this.id,
//       required this.title,
//       required this.imageUrl,
//       required this.price});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        header: GridTileBar(
          backgroundColor: Colors.black54,
          leading: IconButton(
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              cart.addItem(
                productData.id,
                productData.title,
                productData.price,
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 3),
                  content: const Text('Item added to a cart!'),
                  // backgroundColor: Colors.black,
                  action: SnackBarAction(
                    onPressed: () {
                      cart.removeSingleItem(productData.id);
                    },
                    label: 'UNDO',
                  ),
                ),
              );
            },
          ),
          title: Text(productData.title),
          trailing: Consumer<Product>(
            builder: (ctx, value, _) => IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: Icon(
                  value.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                productData.toggleFavorite(authData.token, authData.userId);
              },
            ),
          ),
        ),
        footer: GridTileBar(
          trailing: Text(
            '\$${productData.price}',
            style: const TextStyle(
              color: Colors.white,
              backgroundColor: Colors.black54,
              fontSize: 15,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: productData.id);
          },
          child: Image.network(
            productData.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
