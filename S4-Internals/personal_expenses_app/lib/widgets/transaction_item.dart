import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  final Transaction transaction;
  final Function deleteTransaction;

  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTransaction,
  }) : super(key: key);

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;

  @override
  void initState() {
    const _availableColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
    ];

    _bgColor = _availableColors[Random().nextInt(_availableColors.length)];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 8,
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 32,
            backgroundColor: _bgColor,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: FittedBox(
                child: Text(
                  '\$${widget.transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          title: Text(
            '${widget.transaction.title}',
            style: Theme.of(context).textTheme.title,
          ),
          subtitle: Text(
            DateFormat.yMMMd().format(widget.transaction.date),
          ),
          trailing: MediaQuery.of(context).size.width > 400
              ? FlatButton.icon(
                  icon: Icon(Icons.delete),
                  label: Text('Delete'),
                  textColor: Colors.red,
                  onPressed: () =>
                      widget.deleteTransaction(widget.transaction.id),
                )
              : IconButton(
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () =>
                      widget.deleteTransaction(widget.transaction.id),
                ),
        ),
      ),
    );
  }
}
