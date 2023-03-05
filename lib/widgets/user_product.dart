import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

import '../providers/products_provider.dart';

import '../screens/edit_product_screen.dart';

class UserProduct extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? id;
  final Product removeProduct;

  UserProduct(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.removeProduct});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(10),
      shadowColor: Theme.of(context).colorScheme.primary,
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id),
              ),
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                  onPressed: () {
                    Provider.of<ProductsProvider>(context, listen: false)
                        .deleteProduct(id, removeProduct);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     duration: const Duration(seconds: 6),
                    //     content: const Text('You just removed a product.'),
                    //     // backgroundColor: Colors.black,
                    //     action: SnackBarAction(
                    //       onPressed: () {
                    //         Provider.of<ProductsProvider>(context,
                    //                 listen: false)
                    //             .undoDelete(id, removeProduct);
                    //       },
                    //       label: 'UNDO',
                    //     ),
                    //   ),
                    // );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
