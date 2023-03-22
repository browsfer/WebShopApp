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

  UserProduct({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(10),
      shadowColor: Theme.of(context).colorScheme.primary,
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Builder(builder: (context) {
          return Container(
            width: 100,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id),
                ),
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).errorColor,
                    ),
                    onPressed: () async {
                      try {
                        await Provider.of<ProductsProvider>(context,
                                listen: false)
                            .deleteProduct(id);
                      } catch (error) {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              error.toString(),
                              textAlign: TextAlign.center,
                            ),
                            duration: const Duration(seconds: 5),
                          ),
                        );
                      }
                    }),
              ],
            ),
          );
        }),
      ),
    );
  }
}
