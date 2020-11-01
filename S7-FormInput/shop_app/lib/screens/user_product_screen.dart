import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_user_product_screen.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import './edit_user_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context);
    final loadProducts = product.products;

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('User Products'),
        actions: [
          new IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context)
                .pushNamed(EditUserProductScreen.routeName),
          ),
        ],
      ),
      body: new Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 8,
        ),
        child: new ListView.builder(
          itemCount: loadProducts.length,
          itemBuilder: (context, index) => new UserProductItem(
            productId: loadProducts[index].id,
            productTitle: loadProducts[index].title,
            productImageUrl: loadProducts[index].imageUrl,
            productPrice: loadProducts[index].price,
          ),
        ),
      ),
    );
  }
}
