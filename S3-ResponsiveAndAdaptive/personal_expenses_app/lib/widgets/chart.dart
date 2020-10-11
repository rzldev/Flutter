import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';

import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  Chart(this.recentTransaction);

  List<Map<String, Object>> get groupedTransaction {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0;

      for (int x = 0; x < recentTransaction.length; x++) {
        if (recentTransaction[x].date.day == weekDay.day &&
            recentTransaction[x].date.month == weekDay.month &&
            recentTransaction[x].date.year == weekDay.year) {
          totalSum += recentTransaction[x].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransaction.fold(0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransaction.map((transaction) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                transaction['day'],
                transaction['amount'],
                totalSpending == 0
                    ? 0
                    : (transaction['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
