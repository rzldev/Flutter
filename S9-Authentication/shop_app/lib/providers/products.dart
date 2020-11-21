import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/product.dart';
import '../dummy_products.dart' as dummy;

class Products with ChangeNotifier {
  final String userId, tokenId;

  Products(this.tokenId, this.userId);

  List<Product> _dummy_products = dummy.dummy_products;

  List<Product> _loadedProducts = [];
  List<Product> _ownedProduct = [];

  String url = DotEnv().env['API_URL'];

  List<Product> get products {
    return [..._loadedProducts];
  }

  List<Product> get ownedProducts {
    return [..._ownedProduct];
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

  Future initProducts() async {
    await fetchProducts();
    await fetchProducts(productOwned: true);
  }

  Future fetchProducts({bool productOwned = false}) async {
    String urlSegment = url;

    if (productOwned) {
      urlSegment =
          urlSegment + 'products.json?orderBy="ownerId"&equalTo="$userId"';
      clearLoadedProducts(ownedProducts: true);
    } else {
      urlSegment = urlSegment + 'products.json';
      clearLoadedProducts();
    }

    String urlFavoriteProducts =
        url + 'users/$userId/favoriteProducts.json?auth=$tokenId';

    try {
      final response = await http.get(urlSegment);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final favoriteResponse = await http.get(urlFavoriteProducts);
      final favoriteData = json.decode(favoriteResponse.body);

      if (extractedData == null) {
        await insertInitProducts();
      } else {
        extractedData.forEach((key, data) {
          productOwned
              ? _ownedProduct.add(Product(
                  id: key,
                  userId: data['ownerId'],
                  title: data['title'],
                  description: data['description'],
                  price: double.parse(data['price']),
                  imageUrl: data['imageUrl'],
                ))
              : _loadedProducts.add(Product(
                  id: key,
                  userId: data['ownerId'],
                  title: data['title'],
                  description: data['description'],
                  price: double.parse(data['price']),
                  imageUrl: data['imageUrl'],
                  isFavorite: favoriteData != null ?? favoriteData[key] != null
                      ? true
                      : false,
                ));
        });
      }

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future addProduct(Product product) async {
    String urlSegment = '${url}products.json?auth=$tokenId';

    final Map<String, String> requestHeader = {
      'Content-Type': 'application/json; charset=UTF-8'
    };

    final Map<String, dynamic> requestBody = {
      'ownerId': userId,
      'title': product.title,
      'price': product.price.toString(),
      'description': product.description,
      'imageUrl': product.imageUrl,
      'isFavorite': product.isFavorite,
    };

    try {
      final response = await http.post(
        urlSegment,
        headers: requestHeader,
        body: json.encode(requestBody),
      );

      final responseBody = json.decode(response.body);

      final newProduct = Product(
        id: responseBody['name'],
        userId: product.userId,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      if (responseBody['error'] == null) {
        _loadedProducts.add(newProduct);
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void clearLoadedProducts({bool ownedProducts = false}) {
    if (ownedProducts) {
      _ownedProduct = [];
    } else {
      _loadedProducts = [];
    }
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
