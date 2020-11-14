import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  const CartItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });

  double get itemTotalAmount {
    final totalAmount = this.price * this.quantity;

    return totalAmount;
  }
}
