import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_shop/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final routeId = ModalRoute.of(context)?.settings.arguments as String;

    final loadedProduct =
        Provider.of<ProductsProvider>(context, listen: false).findById(routeId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.network(loadedProduct.imageUrl),
          ),
          const SizedBox(height: 10),
          Text(
            '\$${loadedProduct.price}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text(loadedProduct.description)
        ]),
      ),
    );
  }
}
