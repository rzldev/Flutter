import 'package:flutter/foundation.dart';

import '../models/cart.dart';

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
