import 'package:flutter/material.dart';

import '../screens/transaction_screen.dart';

class BadgeCart extends StatelessWidget {
  final int totalItems;

  const BadgeCart({this.totalItems = 0});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(TransactionScreen.routeName),
      child: new Stack(
        alignment: Alignment.center,
        children: [
          new Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: const Icon(
              Icons.shopping_cart,
            ),
          ),
          new Positioned(
            top: 10,
            right: 6,
            child: new Container(
              height: 18,
              padding: const EdgeInsets.all(2),
              constraints: const BoxConstraints(
                minWidth: 18,
              ),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(8),
                color: Theme.of(context).accentColor,
              ),
              child: new FittedBox(
                child: new Text(
                  '${totalItems}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
