import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  final String url = '${DotEnv().env['API_URL']}products/';

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future toggleFavorite() async {
    final Map<String, String> requestHeader = {
      'Content-Type': 'application/json; charset=UTF-8'
    };

    final Map<String, dynamic> requestBody = {
      'title': title,
      'price': price.toString(),
      'description': description,
      'imageUrl': imageUrl,
      'isFavorite': !isFavorite,
    };

    try {
      final response = await http.patch(
        '${url}${id}.json',
        headers: requestHeader,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        isFavorite = json.decode(response.body)['isFavorite'];
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
