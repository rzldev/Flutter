import 'package:flutter/material.dart';

import '../providers/cart.dart';

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
                                    text: ' (\$${cartItem.price})',
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
                              '\$${cartItem.itemTotalAmount}',
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
                          new IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                cart.removeItem(cartItem.productId);
                              }),
                          const SizedBox(
                            width: 8,
                          ),
                          new IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.grey,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
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
                          new IconButton(
                              icon: const Icon(
                                Icons.add_circle,
                                color: Colors.grey,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
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
