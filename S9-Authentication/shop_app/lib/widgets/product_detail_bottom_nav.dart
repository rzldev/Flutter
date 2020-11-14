import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/carts.dart';
import '../screens/transaction_screen.dart';

class ProductDetailBottomNav extends StatelessWidget {
  final String id, title;
  final double price;

  const ProductDetailBottomNav({
    @required this.id,
    @required this.title,
    @required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return new Container(
      padding: const EdgeInsets.all(8),
      decoration: new BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          const BoxShadow(
            color: Colors.grey,
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          new Container(
            decoration: new BoxDecoration(
              border: new Border.all(
                width: 2,
                color: Theme.of(context).accentColor,
              ),
              borderRadius: const BorderRadius.all(
                const Radius.circular(8),
              ),
              color: Colors.white,
            ),
            child: new IconButton(
              icon: new Icon(
                Icons.add_shopping_cart_sharp,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                cart.addItem(id, title, price);

                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(new SnackBar(
                  content: const Text('Item added to cart.'),
                  duration: const Duration(seconds: 2),
                  action: new SnackBarAction(
                    label: 'UNDO',
                    textColor: Theme.of(context).errorColor,
                    onPressed: () {
                      cart.removeSingleItem(id);
                    },
                  ),
                ));
              },
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          new Expanded(
            child: new Container(
              decoration: new BoxDecoration(
                border: new Border.all(
                  width: 2,
                  color: Theme.of(context).accentColor,
                ),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(8),
                ),
                color: Theme.of(context).accentColor,
              ),
              child: new FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    TransactionScreen.routeName,
                    arguments: id,
                  );
                },
                child: const Text(
                  'Buy Now',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
