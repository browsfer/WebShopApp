import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:developer';

import '../models/http_exception.dart';
import 'product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product?> _products = [];

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
