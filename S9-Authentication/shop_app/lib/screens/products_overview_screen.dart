import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/products.dart';
import '../providers/carts.dart';
import '../widgets/products_overview_item.dart';
import '../widgets/badge_cart.dart';
import '../widgets/error_snackbar.dart';

enum FilterOptions {
  All,
  Favorites,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/overview-product';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

Widget buildGrid(BuildContext context, bool showFavorite) {
  final products = Provider.of<Products>(context);
  final List<Product> loadProducts =
      showFavorite ? products.favoriteProduct : products.products;

  return new Padding(
    padding: const EdgeInsets.all(8.0),
    child: new StaggeredGridView.countBuilder(
      primary: true,
      crossAxisCount: 4,
      itemCount: loadProducts.length,
      itemBuilder: (context, index) {
        return new ChangeNotifierProvider.value(
          value: loadProducts[index],
          child: new ProductsOverviewItem(),
        );
      },
      staggeredTileBuilder: (index) {
        return new StaggeredTile.fit(2);
      },
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
    ),
  );
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showOnlyFavorites = false;

  Future _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchProducts()
        .catchError((_) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(new ErrorSnackbar(
        context,
      ).showErrorSnackBar());
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text('Overview Product'),
        actions: [
          new Consumer<Cart>(
            builder: (context, cart, child) => new BadgeCart(
              totalItems: cart.countItems,
            ),
          ),
          new PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              new PopupMenuItem(
                child: const Text('Show All'),
                value: FilterOptions.All,
              ),
              new PopupMenuItem(
                child: const Text('Show Favorites'),
                value: FilterOptions.Favorites,
              ),
            ],
          )
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: buildGrid(context, _showOnlyFavorites)),
    );
  }
}
