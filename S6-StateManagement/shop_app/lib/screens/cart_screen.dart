import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_list.dart';
import '../providers/cart.dart';
import '../providers/order.dart';
import '../providers/products.dart';

class CartScreen extends StatelessWidget {
  static const routeName = './cart';

  final TabController tabController;
  final String id;

  CartScreen({
    @required this.tabController,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    Cart cart;

    if (id != null) {
      final products = Provider.of<Products>(context);
      final Product loadProduct = products.findProduct(id);

      cart = new Cart();
      cart.addItem(
        loadProduct.id,
        loadProduct.title,
        loadProduct.price,
      );
    } else {
      cart = Provider.of<Cart>(context);
    }

    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          padding: const EdgeInsets.all(8),
          child: new Column(
            children: [
              // new Row(
              //   children: [
              // new Checkbox(value: null, onChanged: null),
              // const Text('Check All'),
              //   ],
              // ),
              new CartList(
                cart: cart,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: new Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: new BoxDecoration(
          color: Colors.white,
          boxShadow: [
            new BoxShadow(
              blurRadius: 4,
              spreadRadius: 0,
              color: Colors.black45,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            new Row(
              children: [
                const Text('Total : '),
                new Text(
                  '\$${cart.totalAmount}',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            new RaisedButton(
              color: Theme.of(context).accentColor,
              child: const Text(
                'Order Now',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Provider.of<Orders>(context, listen: false).addOrder(
                  cart.items.values.toList(),
                  cart.totalAmount,
                );

                cart.clear();

                tabController.animateTo(1);
              },
            ),
          ],
        ),
      ),
    );
  }
}
