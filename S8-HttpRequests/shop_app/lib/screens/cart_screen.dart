import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

import '../widgets/cart_list.dart';
import '../widgets/loading_screen.dart';
import '../models/product.dart';
import '../providers/carts.dart';
import '../providers/orders.dart';
import '../providers/products.dart';

class CartScreen extends StatefulWidget {
  static const routeName = './cart';

  final TabController tabController;
  final String id;

  CartScreen({
    @required this.tabController,
    this.id,
  });

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  Future orderingItem(Cart cart, BuildContext context) async {
    setState(() => _isLoading = true);

    await Provider.of<Orders>(context, listen: false)
        .addOrder(
      cart.items.values.toList(),
      cart.totalAmount,
    )
        .then((value) {
      setState(() => _isLoading = false);

      cart.clear();

      widget.tabController.animateTo(1);
    }).catchError((onError) {
      setState(() => _isLoading = false);

      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Text('Something went wrong!'),
        duration: Duration(seconds: 1),
        action: SnackBarAction(
          label: 'Ok',
          textColor: Theme.of(context).errorColor,
          onPressed: () {},
        ),
      ));

      throw (onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    Cart cart;

    if (widget.id != null) {
      final products = Provider.of<Products>(context);
      final Product loadProduct = products.findProduct(widget.id);

      cart = new Cart();
      cart.addItem(
        loadProduct.id,
        loadProduct.title,
        loadProduct.price,
      );
    } else {
      cart = Provider.of<Cart>(context);
    }

    return new LoadingScreen(
      status: _isLoading,
      child: new Scaffold(
        key: _scaffoldKey,
        body: new SingleChildScrollView(
          child: new Container(
            padding: const EdgeInsets.all(8),
            child: new Column(
              children: [
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
                    FlutterMoneyFormatter(amount: cart.totalAmount)
                        .output
                        .symbolOnLeft,
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
                onPressed: () => orderingItem(cart, context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
