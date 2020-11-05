import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

import '../models/cart.dart';
import '../providers/carts.dart';

class CartList extends StatelessWidget {
  final Cart cart;

  const CartList({@required this.cart});

  @override
  Widget build(BuildContext context) {
    Map<String, CartItem> loadedCart = cart.items;

    return new Container(
      child: new ListView.builder(
          itemCount: loadedCart.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final CartItem cartItem = loadedCart.values.toList()[index];
            TextEditingController quantityController =
                new TextEditingController();
            quantityController.value =
                new TextEditingValue(text: cartItem.quantity.toString());

            return new Dismissible(
              key: new ValueKey(cartItem.id),
              background: new Container(
                color: Theme.of(context).errorColor,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 40,
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
              ),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) {
                return showDialog(
                    context: context,
                    builder: (context) =>
                        DeleteItemDialog(removeHandler: () {}));
              },
              onDismissed: (direction) {
                cart.removeItem(cartItem.productId);
              },
              child: new Card(
                child: new Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: new Column(
                    children: [
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          new Expanded(
                            child: new RichText(
                              maxLines: 5,
                              text: new TextSpan(
                                text: cartItem.title,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                children: <TextSpan>[
                                  new TextSpan(
                                    text:
                                        ' (${FlutterMoneyFormatter(amount: cartItem.price).output.symbolOnLeft})',
                                    style: new TextStyle(
                                      fontSize: 16,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              FlutterMoneyFormatter(
                                      amount: cartItem.itemTotalAmount)
                                  .output
                                  .symbolOnLeft,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CartIconButton(
                              icon: new Icon(
                                Icons.delete,
                                color: Theme.of(context).errorColor,
                              ),
                              buttonHandler: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DeleteItemDialog(removeHandler: () {
                                      cart.removeItem(cartItem.productId);
                                    });
                                  },
                                );
                              }),
                          const SizedBox(
                            width: 8,
                          ),
                          CartIconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.grey,
                              ),
                              buttonHandler: () {
                                cart.setQuantity(
                                    productId: cartItem.productId,
                                    mode: 'subtract');
                              }),
                          new Container(
                              width: 40,
                              child: new TextField(
                                controller: quantityController,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                keyboardType: TextInputType.number,
                                decoration: new InputDecoration(
                                  enabledBorder: new UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: new UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 2,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 4,
                                  ),
                                ),
                                onChanged: (value) {
                                  cart.setQuantity(
                                    productId: cartItem.productId,
                                    qty: int.parse(value),
                                  );
                                },
                              )),
                          CartIconButton(
                              icon: const Icon(
                                Icons.add_circle,
                                color: Colors.grey,
                              ),
                              buttonHandler: () {
                                cart.setQuantity(
                                    productId: cartItem.productId, mode: 'add');
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class CartIconButton extends StatelessWidget {
  final Icon icon;
  final Function buttonHandler;

  const CartIconButton({@required this.icon, @required this.buttonHandler});

  @override
  Widget build(BuildContext context) {
    return new IconButton(
        icon: icon,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () {
          buttonHandler();
        });
  }
}

class DeleteItemDialog extends StatelessWidget {
  final Function removeHandler;

  const DeleteItemDialog({@required this.removeHandler});

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: const Text('Delete'),
      content:
          const Text('Are you sure want to delete this item from the cart?'),
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
