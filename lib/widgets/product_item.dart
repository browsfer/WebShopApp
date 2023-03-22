import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/providers/cart.dart';
import '/providers/product.dart';
import '/providers/auth.dart';

import '/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Card(
          shadowColor: Theme.of(context).colorScheme.secondary,
          child: Column(
            children: [
              Card(
                shadowColor: Theme.of(context).colorScheme.secondary,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: IconButton(
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
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        productData.title,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Consumer<Product>(
                        builder: (ctx, value, _) => IconButton(
                          color: Theme.of(context).colorScheme.secondary,
                          icon: Icon(value.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border),
                          onPressed: () {
                            productData.toggleFavorite(
                                authData.token, authData.userId);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        ProductDetailScreen.routeName,
                        arguments: productData.id);
                  },
                  child: Hero(
                    tag: productData.id!,
                    child: FadeInImage(
                      fadeOutDuration: Duration(milliseconds: 200),
                      placeholder: const AssetImage(
                          'assets/images/product-placeholder.png'),
                      image: NetworkImage(productData.imageUrl),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // return ClipRRect(
      //   borderRadius: BorderRadius.circular(10),
      //   child: GridTile(
      //     header: GridTileBar(
      //       backgroundColor: Colors.black54,
      //       leading: IconButton(
      //         icon: const Icon(Icons.shopping_cart),
      //         color: Theme.of(context).colorScheme.secondary,
      //         onPressed: () {
      //           cart.addItem(
      //             productData.id,
      //             productData.title,
      //             productData.price,
      //           );
      //           ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //           ScaffoldMessenger.of(context).showSnackBar(
      //             SnackBar(
      //               duration: const Duration(seconds: 3),
      //               content: const Text('Item added to a cart!'),
      //               // backgroundColor: Colors.black,
      //               action: SnackBarAction(
      //                 onPressed: () {
      //                   cart.removeSingleItem(productData.id);
      //                 },
      //                 label: 'UNDO',
      //               ),
      //             ),
      //           );
      //         },
      //       ),
      //       title: Text(productData.title),
      //       trailing: Consumer<Product>(
      //         builder: (ctx, value, _) => IconButton(
      //           color: Theme.of(context).colorScheme.secondary,
      //           icon: Icon(
      //               value.isFavorite ? Icons.favorite : Icons.favorite_border),
      //           onPressed: () {
      //             productData.toggleFavorite(authData.token, authData.userId);
      //           },
      //         ),
      //       ),
      //     ),
      //     footer: GridTileBar(
      //       trailing: Text(
      //         '${productData.price}zł',
      //         style: const TextStyle(
      //           color: Colors.white,
      //           backgroundColor: Colors.black54,
      //           fontSize: 15,
      //           fontWeight: FontWeight.w200,
      //         ),
      //       ),
      //     ),
      //     child: GestureDetector(
      //       onTap: () {
      //         Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
      //             arguments: productData.id);
      //       },
      //       child: Column(
      //         children: [
      //           Hero(
      //             tag: productData.id!,
      //             child: FadeInImage(
      //               placeholder:
      //                   const AssetImage('assets/images/product-placeholder.png'),
      //               image: NetworkImage(productData.imageUrl),
      //               fit: BoxFit.cover,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // );
    );
  }
}
