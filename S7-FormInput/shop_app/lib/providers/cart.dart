import 'package:flutter/foundation.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

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
    final totalAmount =
        new FlutterMoneyFormatter(amount: this.price * this.quantity)
            .output
            .nonSymbol;

    return double.parse(totalAmount);
  }
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get countItems {
    return _items.length;
  }

  void addItem(
    String productId,
    String title,
    double price,
  ) {
    if (_items.containsKey(productId)) {
      // Change Quantity
      _items.update(
        productId,
        (existingCartItem) => new CartItem(
          id: existingCartItem.id,
          productId: existingCartItem.productId,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => new CartItem(
          id: new DateTime.now().toString(),
          productId: productId,
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (item) => CartItem(
                id: item.id,
                productId: item.productId,
                title: item.title,
                quantity: item.quantity - 1,
                price: item.price,
              ));
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  String itemTotalAmount(String productId) {
    final item =
        _items.values.firstWhere((item) => item.productId == productId);

    return item.quantity.toString();
  }

  double get totalAmount {
    double total = 0;

    _items.forEach((key, cartItem) {
      total += (cartItem.price * cartItem.quantity);
    });

    return double.parse(
        new FlutterMoneyFormatter(amount: total).output.nonSymbol);
  }

  void setQuantity({@required String productId, String mode, int qty}) {
    if (qty != null) {
      _items.update(
        productId,
        (cartItem) => new CartItem(
          id: cartItem.id,
          productId: cartItem.productId,
          title: cartItem.title,
          quantity: qty,
          price: cartItem.price,
        ),
      );
    }

    if (mode == 'add') {
      _items.update(
        productId,
        (cartItem) => new CartItem(
          id: cartItem.id,
          productId: cartItem.productId,
          title: cartItem.title,
          quantity: cartItem.quantity + 1,
          price: cartItem.price,
        ),
      );
    } else if (mode == 'subtract') {
      _items.update(
        productId,
        (cartItem) => new CartItem(
          id: cartItem.id,
          productId: cartItem.productId,
          title: cartItem.title,
          quantity: cartItem.quantity <= 1 ? 1 : cartItem.quantity - 1,
          price: cartItem.price,
        ),
      );
    }

    notifyListeners();
  }

  void clear() {
    _items = {};

    notifyListeners();
  }
}
