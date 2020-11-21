import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../providers/auth.dart';

class Product with ChangeNotifier {
  final String id;
  String userId;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    this.userId = '',
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  final url = DotEnv().env['API_URL'];

  Future toggleFavorite(String token, userId) async {
    final urlSegment =
        '${url}users/$userId/favoriteProducts/$id.json?auth=$token';

    final Map<String, String> requestHeader = {
      'Content-Type': 'application/json; charset=UTF-8'
    };

    final productStatus = !isFavorite;

    try {
      final response = productStatus
          ? await http.put(
              urlSegment,
              headers: requestHeader,
              body: json.encode(productStatus),
            )
          : await http.delete(
              urlSegment,
            );

      if (response.statusCode <= 400) {
        isFavorite = productStatus;
        notifyListeners();
      }

      print(isFavorite);
    } catch (error) {
      throw (error);
    }
  }
}
