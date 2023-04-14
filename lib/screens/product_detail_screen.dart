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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: const IconThemeData(color: Colors.black, size: 40),
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.black.withOpacity(0.6),
                ),
                child: Text(
                  loadedProduct!.title,
                ),
              ),
              background: Hero(
                tag: loadedProduct.id!,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 10),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                        width: 1, color: Theme.of(context).primaryColor),
                  ),
                  child: Text(
                    '\$${loadedProduct.price}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Text(
                  loadedProduct.description,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
