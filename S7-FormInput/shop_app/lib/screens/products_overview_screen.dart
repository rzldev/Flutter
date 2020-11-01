import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/cart.dart';
import '../widgets/products_overview_item.dart';
import '../widgets/badge_cart.dart';

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

  // final cart = Provider.of<Cart>(context, listen: false);

  // print(loadProducts.length);
  // print(showFavorite);

  return new Padding(
    padding: const EdgeInsets.all(8.0),
    // child: GridView.builder(
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     childAspectRatio: 4 / 5,
    //     crossAxisCount: 2,
    //     crossAxisSpacing: 12,
    //     mainAxisSpacing: 12,
    //   ),
    //   itemCount: loadProducts.length,
    //   itemBuilder: (context, index) {
    //     return ChangeNotifierProvider.value(
    //       builder: (context, child) => ProductsOverviewItem(
    //           // id: loadProducts[index].id,
    //           // title: loadProducts[index].title,
    //           // imageUrl: loadProducts[index].imageUrl,
    //           ),
    //       value: loadProducts[index],
    //     );
    //   },
    // ),

    child: new StaggeredGridView.countBuilder(
      primary: true,
      crossAxisCount: 4,
      itemCount: loadProducts.length,
      itemBuilder: (context, index) {
        return new ChangeNotifierProvider.value(
          value: loadProducts[index],
          child: new ProductsOverviewItem(),
        );
        // ProductsOverviewItem(
        //   id: loadProducts[index].id,
        //   title: loadProducts[index].title,
        //   imageUrl: loadProducts[index].imageUrl,
        // );
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
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
      body: buildGrid(context, _showOnlyFavorites),
    );
  }
}
