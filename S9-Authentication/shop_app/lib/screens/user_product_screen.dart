import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_user_product_screen.dart';

import '../providers/products.dart';
import './edit_user_product_screen.dart';
import '../widgets/user_product_item.dart';
import '../widgets/error_snackbar.dart';

class UserProductScreen extends StatefulWidget {
  @override
  _UserProductScreenState createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  Future _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchProducts(productOwned: true)
        .catchError((_) {
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
            content: const Text('Something went wrong!'),
            duration: const Duration(seconds: 2),
            action: new SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final loadProducts = Provider.of<Products>(context).products;

    return new Scaffold(
      key: _scaffoldKey,
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
      body: new RefreshIndicator(
        onRefresh: () async =>
            await Provider.of<Products>(context, listen: false)
                .fetchProducts()
                .catchError((_) {
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context)
              .showSnackBar(new ErrorSnackbar(context).showErrorSnackBar());
        }),
        child: new Padding(
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
      ),
    );
  }
}
