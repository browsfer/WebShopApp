import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:developer';

import '../models/http_exception.dart';
import 'product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product?> _products = [
    //   Product(
    //     id: 'p1',
    //     title: 'Red Shirt',
    //     description: 'A red shirt - it is pretty red!',
    //     price: 29.99,
    //     imageUrl:
    //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //   ),
    //   Product(
    //     id: 'p2',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //   ),
    //   Product(
    //     id: 'p3',
    //     title: 'Yellow Scarf',
    //     description: 'Warm and cozy - exactly what you need for the winter.',
    //     price: 19.99,
    //     imageUrl:
    //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //   ),
    //   Product(
    //     id: 'p4',
    //     title: 'A Pan',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   ),
  ];

  final String? authToken;
  final String? userId;

  ProductsProvider(this.authToken, this.userId, this._products);

  List<Product?> get products {
    return [..._products];
  }

  List<Product?> get onlyFavorite {
    return _products.where((prodItem) => prodItem!.isFavorite).toList();
  }

  Future<void> fetchAndAddproducts([bool filterByUser = false]) async {
    final filteredByUser =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    try {
      final response = await http.get(Uri.parse(
          'https://fluttercourse-4800b-default-rtdb.europe-west1.firebasedatabase.app/productsprovider.json?auth=$authToken&$filteredByUser'));

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        return;
      }

      final favoritesResponse = await http.get(Uri.parse(
          'https://fluttercourse-4800b-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken'));

      final favoriteData = json.decode(favoritesResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      _products = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://fluttercourse-4800b-default-rtdb.europe-west1.firebasedatabase.app/productsprovider.json?auth=$authToken'),
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          }));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Product? findById(String? id) {
    return _products.firstWhere((prod) => prod!.id == id);
  }

  Future<void> updateProduct(String? id, Product updatedProduct) async {
    final productIndex = _products.indexWhere((prod) => prod?.id == id);
    if (productIndex >= 0) {
      await http.patch(
        Uri.parse(
            'https://fluttercourse-4800b-default-rtdb.europe-west1.firebasedatabase.app/productsprovider/$id.json?auth=$authToken'),
        body: json.encode(
          {
            'title': updatedProduct.title,
            'price': updatedProduct.price,
            'description': updatedProduct.description,
            'imageUrl': updatedProduct.imageUrl,
          },
        ),
      );

      _products[productIndex] = updatedProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String? id) async {
    final existingProductIndex = _products.indexWhere((prod) => prod!.id == id);
    var existingProduct = _products[existingProductIndex];

    _products.removeAt(existingProductIndex);
    notifyListeners();

    final result = await http.delete(
      Uri.parse(
          'https://fluttercourse-4800b-default-rtdb.europe-west1.firebasedatabase.app/productsprovider/$id.json?auth=$authToken'),
    );
    if (result.statusCode >= 400) {
      _products.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Deleting product failed');
    }
    existingProduct = null;
  }
}
