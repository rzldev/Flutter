import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/cart.dart';
import '../models/order.dart';

class Orders with ChangeNotifier {
  final String authToken;
  List<OrderItem> _orders = [];

  Orders(this.authToken, this._orders);

  String url = '${DotEnv().env['API_URL']}orders.json';

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future fetchOrdersData() async {
    url = url + '?auth=$authToken';

    try {
      final response = await http.get(url);
      final extractedData =
          await json.decode(response.body) as Map<String, dynamic>;

      clearOrders();

      if (extractedData == null) {
        return;
      }

      if (response.statusCode == 200) {
        if (response.body != null) {
          extractedData.forEach((key, data) {
            _orders.add(new OrderItem(
              id: key,
              cartList: (data['items'] as List<dynamic>)
                  .map((item) => new CartItem(
                        id: item['id'],
                        productId: item['productId'],
                        title: item['title'],
                        quantity: int.parse(item['quantity'].toString()),
                        price: double.parse(item['price'].toString()),
                      ))
                  .toList(),
              amount: data['amount'],
              dateTime: DateTime.parse(data['timestamp']),
            ));
          });
        }

        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  void clearOrders() {
    _orders = [];
    notifyListeners();
  }

  Future addOrder(List<CartItem> cartList, double amount) async {
    url = url + '?auth=$authToken';

    final Map<String, String> requestHeader = {
      'Content-Type': 'application/json; charset=UTF-8'
    };

    final timestamp = new DateTime.now();

    final Map<String, dynamic> requestBody = {
      'items': cartList
          .map((cartItem) => {
                'id': cartItem.id,
                'productId': cartItem.productId,
                'title': cartItem.title,
                'price': cartItem.price,
                'quantity': cartItem.quantity,
              })
          .toList(),
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
    };

    try {
      final response = await http.post(
        url,
        headers: requestHeader,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        _orders.add(new OrderItem(
          id: json.decode(response.body)['name'],
          cartList: cartList,
          amount: amount,
          dateTime: timestamp,
        ));

        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
