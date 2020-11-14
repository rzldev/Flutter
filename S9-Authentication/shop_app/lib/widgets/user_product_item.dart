import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_user_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String productId;
  final String productTitle;
  final String productImageUrl;
  final double productPrice;

  const UserProductItem({
    @required this.productId,
    @required this.productTitle,
    @required this.productImageUrl,
    @required this.productPrice,
  });

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.only(
          left: 16,
          right: 8,
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(productImageUrl),
        ),
        title: Text(productTitle),
        subtitle: Text('\$${productPrice}'),
        trailing: PopupMenuButton(
          icon: Icon(Icons.more_vert),
          padding: EdgeInsets.zero,
          onSelected: (value) {
            // print(value);
            if (value == 0) {
              Navigator.of(context).pushNamed(EditUserProductScreen.routeName,
                  arguments: {'id': productId});
            } else if (value == 1) {
              showDialog(
                context: context,
                builder: (context) => DeleteItemDialog(removeHandler: () {
                  products.removeProduct(productId);
                }),
              );
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Text('Edit'),
              value: 0,
            ),
            PopupMenuItem(
              child: Text('Remove'),
              value: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteItemDialog extends StatelessWidget {
  final Function removeHandler;

  const DeleteItemDialog({@required this.removeHandler});

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: const Text('Delete'),
      content: const Text('Are you sure want to delete this item?'),
      actions: [
        new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: const TextStyle(
                color: Colors.grey,
              ),
            )),
        new FlatButton(
            onPressed: () {
              removeHandler();
              Navigator.of(context).pop(true);
            },
            child: new Text(
              'Delete',
              style: new TextStyle(
                color: Theme.of(context).errorColor,
              ),
            )),
      ],
    );
  }
}
