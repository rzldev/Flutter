import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/cart.dart';

class OrderItem extends StatefulWidget {
  final DateTime orderDatetime;
  final double orderAmount;
  final List<CartItem> orderCartList;

  const OrderItem({
    @required this.orderDatetime,
    @required this.orderAmount,
    @required this.orderCartList,
  });

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _showDetail = true;

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        children: [
          new ListTile(
            title: new Text(
              '\$${widget.orderAmount}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: new Text(
              '${DateFormat.yMMMd().add_jm().format(widget.orderDatetime)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            trailing: new IconButton(
                icon: new Icon(
                    _showDetail ? Icons.expand_more : Icons.expand_less),
                onPressed: () {
                  setState(() {
                    _showDetail = !_showDetail;
                  });
                }),
          ),
          if (_showDetail)
            new Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 12,
              ),
              child: new ListView.builder(
                itemCount: widget.orderCartList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final cart = widget.orderCartList[index];

                  return new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Expanded(
                        child: new Text(
                          '${cart.title} (${cart.quantity} x \$${cart.price})',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      new Text('\$${cart.itemTotalAmount}'),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
