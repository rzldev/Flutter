import 'package:flutter/material.dart';
import 'package:personal_expenses_app/widgets/transaction_item.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  const TransactionList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    print('build() TransactionList');

    return Container(
      height: 400,
      child: transactions.isEmpty
          ? LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width > 400
                          ? constraints.maxHeight * 0.8
                          : constraints.maxHeight * 0.6,
                      padding: EdgeInsets.all(8),
                      child: Image.asset(
                        'assets/images/garfield.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.05,
                    ),
                    Container(
                      height: constraints.maxHeight * 0.15,
                      child: Text(
                        "You don't have any transaction",
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  ],
                );
              },
            )
          : ListView(
              children: transactions.map((transaction) {
                return TransactionItem(
                  key: ValueKey(transaction.id),
                  transaction: transaction,
                  deleteTransaction: deleteTransaction,
                );
              }).toList(),
            ),
    );
  }
}
