import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/cart.dart';
import '../widgets/badge_cart.dart';
import '../widgets/product_detail_bottom_nav.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  Widget spaceBox() {
    return new SizedBox(
      height: 4,
    );
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments;
    final products = Provider.of<Products>(context, listen: false);
    final Product loadProduct = products.findProduct(productId);

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
      bottomNavigationBar: ProductDetailBottomNav(
        id: loadProduct.id,
        title: loadProduct.title,
        price: loadProduct.price,
      ),
    );
  }
}
