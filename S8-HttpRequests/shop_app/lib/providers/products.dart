import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/product.dart';
import '../dummy_products.dart' as dummy;

class Products with ChangeNotifier {
  List<Product> _dummy_products = dummy.dummy_products;

  List<Product> _loadedProducts = [];

  final String url = DotEnv().env['API_URL'];

  List<Product> get products {
    return [..._loadedProducts];
  }

  List<Product> get favoriteProduct {
    return _loadedProducts.where((product) => product.isFavorite).toList();
  }

  Product findProduct(String productId) {
    return _loadedProducts.firstWhere((product) => product.id == productId);
  }

  Future insertInitProducts() async {
    _dummy_products.forEach((product) async {
      await addProduct(product);
    });
  }

  Future fetchProducts() async {
    try {
      final response = await http.get('${url}products.json');
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      clearLoadedProducts();

      if (extractedData == null) {
        await insertInitProducts();
      } else {
        extractedData.forEach((key, data) {
          _loadedProducts.add(Product(
              id: key,
              title: data['title'],
              description: data['description'],
              price: double.parse(data['price']),
              imageUrl: data['imageUrl']));
        });
      }

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future addProduct(Product product) async {
    final Map<String, String> requestHeader = {
      'Content-Type': 'application/json; charset=UTF-8'
    };

    final Map<String, dynamic> requestBody = {
      'title': product.title,
      'price': product.price.toString(),
      'description': product.description,
      'imageUrl': product.imageUrl,
      'isFavorite': product.isFavorite,
    };

    try {
      final response = await http.post(
        '${url}products.json',
        headers: requestHeader,
        body: json.encode(requestBody),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _loadedProducts.add(newProduct);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void clearLoadedProducts() {
    _loadedProducts = [];
  }

  Future updateProduct(String productId, Product newProduct) async {
    final Map<String, String> requestHeader = {
      'Content-Type': 'application/json; charset=UTF-8'
    };

    final Map<String, dynamic> requestBody = {
      'title': newProduct.title,
      'price': newProduct.price.toString(),
      'description': newProduct.description,
      'imageUrl': newProduct.imageUrl,
      'isFavorite': newProduct.isFavorite,
    };

    final String url = '${DotEnv().env['API_URL']}products/${productId}.json';

    try {
      final response = await http.patch(
        url,
        headers: requestHeader,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final int productIndex =
            _loadedProducts.indexWhere((product) => product.id == productId);
        _loadedProducts[productIndex] = newProduct;

        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future removeProduct(String productId) async {
    final String url = '${DotEnv().env['API_URL']}products/${productId}.json';

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        _loadedProducts.removeWhere((product) => product.id == productId);
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
