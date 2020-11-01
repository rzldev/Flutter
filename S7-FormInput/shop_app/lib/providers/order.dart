import 'package:flutter/foundation.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final List<CartItem> cartList;
  final double amount;
  final DateTime dateTime;

  const OrderItem({
    @required this.id,
    @required this.cartList,
    @required this.amount,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final List<OrderItem> _orders = const [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartList, double amount) {
    _orders.insert(
        _orders.length,
        new OrderItem(
          id: new DateTime.now().toString(),
          cartList: cartList,
          amount: amount,
          dateTime: new DateTime.now(),
        ));

    notifyListeners();
  }
}
