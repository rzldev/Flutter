import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/cart.dart';
import '../widgets/badge_cart.dart';
import '../screens/transaction_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  Widget spaceBox() {
    return new SizedBox(
      height: 4,
    );
  }

  Widget buildBorder({
    @required Widget child,
    @required Color backgroundColor,
    @required BuildContext context,
  }) {
    return new Container(
      decoration: new BoxDecoration(
        border: new Border.all(
          width: 2,
          color: Theme.of(context).accentColor,
        ),
        borderRadius: const BorderRadius.all(
          const Radius.circular(8),
        ),
        color: backgroundColor,
      ),
      child: child,
    );
  }

  Widget buildBottomNavBar({
    BuildContext context,
    @required Cart cart,
    @required Product loadProduct,
  }) {
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
          buildBorder(
            context: context,
            backgroundColor: Colors.white,
            child: new IconButton(
              icon: new Icon(
                Icons.add_shopping_cart_sharp,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                cart.addItem(
                  loadProduct.id,
                  loadProduct.title,
                  loadProduct.price,
                );
              },
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          new Expanded(
            child: buildBorder(
              context: context,
              backgroundColor: Theme.of(context).accentColor,
              child: new FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    TransactionScreen.routeName,
                    arguments: loadProduct.id,
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

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments;
    final products = Provider.of<Products>(context, listen: false);
    final Product loadProduct = products.findProduct(productId);

    final cart = Provider.of<Cart>(context, listen: false);

    return new Scaffold(
      appBar: new AppBar(
        // elevation: 0,
        title: new Text(
          loadProduct.title,
        ),
        actions: [
          new Container(
            margin: MediaQuery.of(context).size.width > 400
                ? const EdgeInsets.only(right: 4)
                : const EdgeInsets.only(),
            child: new Consumer<Cart>(
              builder: (context, cart, child) => new BadgeCart(
                totalItems: cart.countItems,
              ),
            ),
          ),
        ],
      ),
      body: new SingleChildScrollView(
        child: new Column(
          children: [
            new Image.network(
              loadProduct.imageUrl,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              fit: BoxFit.contain,
            ),
            new Padding(
              padding: const EdgeInsets.all(20),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  new Row(
                    children: [
                      new Expanded(
                        child: new Text(
                          '\$${loadProduct.price}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      new Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  spaceBox(),
                  new Text(
                    loadProduct.title,
                    style: const TextStyle(fontSize: 20),
                  ),
                  spaceBox(),
                  const Divider(
                    color: Colors.grey,
                  ),
                  const Text(
                    'Description',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  spaceBox(),
                  new Text(
                    loadProduct.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavBar(
        context: context,
        cart: cart,
        loadProduct: loadProduct,
      ),
    );
  }
}
