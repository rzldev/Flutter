import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_user_product_screen.dart';

import '../providers/products.dart';
import '../providers/auth.dart';
import './edit_user_product_screen.dart';
import './auth_screen.dart';
import './auth_screen.dart';
import '../widgets/user_product_item.dart';
import '../widgets/error_snackbar.dart';

class UserProductScreen extends StatefulWidget {
  @override
  _UserProductScreenState createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final loadProducts = Provider.of<Products>(context).ownedProducts;

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
                .fetchProducts(productOwned: true)
                .catchError((_) {
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context)
              .showSnackBar(new ErrorSnackbar(context).showErrorSnackBar());
        }),
        child: new Consumer<Auth>(
          builder: (context, auth, _) => auth.isAuth
              ? new Padding(
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
                )
              : Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('You are not login yet. Please login first.'),
                      const SizedBox(
                        height: 4,
                      ),
                      new RaisedButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(AuthScreen.routeName),
                          color: Theme.of(context).accentColor,
                          child: const Text(
                            'Login',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ))
                    ],
                  ),
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: RaisedButton(
          color: Theme.of(context).accentColor,
          onPressed: () {
            Auth().logout();

            Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
          },
          child: Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
