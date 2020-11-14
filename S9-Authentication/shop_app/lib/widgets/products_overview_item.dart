import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class ProductsOverviewItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);

    return new GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
      },
      child: new Card(
        elevation: 4,
        child: new Column(
          children: [
            new Container(
              height: MediaQuery.of(context).size.width * 0.5,
              width: double.infinity,
              child: new Image.network(
                product.imageUrl,
                fit: BoxFit.fitWidth,
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(8),
              child: new Column(
                children: [
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Expanded(
                          child: new Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        new Consumer<Product>(
                          builder: (context, product, child) =>
                              new GestureDetector(
                            child: new Icon(
                              product.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ),
                            onTap: () async {
                              await product.toggleFavorite();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    width: double.infinity,
                    child: new Text(
                      '\$${product.price}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
