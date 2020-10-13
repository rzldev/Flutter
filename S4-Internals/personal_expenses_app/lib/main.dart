import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './models/transaction.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Personal Expenses App",
      home: MyHomePage(),
      theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.redAccent,
          fontFamily: 'Quicksand',
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                      title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ))),
          textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(
      DateTime.now().toString(),
      'Jordan shoes',
      300,
      DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      DateTime.now().toString(),
      'Weekly groceries',
      100,
      DateTime.now().subtract(Duration(days: 7)),
    ),
    Transaction(
      DateTime.now().toString(),
      'Jordan shoes',
      300,
      DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      DateTime.now().toString(),
      'Jordan shoes',
      300,
      DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      DateTime.now().toString(),
      'Jordan shoes',
      300,
      DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      DateTime.now().toString(),
      'Jordan shoes',
      300,
      DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      DateTime.now().toString(),
      'Jordan shoes',
      300,
      DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      DateTime.now().toString(),
      'Jordan shoes',
      300,
      DateTime.now().subtract(Duration(days: 1)),
    ),
  ];

  bool _showChart = false;

  void _openAddTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return NewTransaction(_addTransaction);
      },
    );
  }

  void _addTransaction(String title, double amount, DateTime date) {
    final newTransaction = Transaction(
      DateTime.now().toString(),
      title,
      amount,
      date,
    );

    if (!title.isEmpty && amount > 0) {
      setState(() {
        _transactions.add(newTransaction);
      });
    }

    Navigator.of(context).pop();
  }

  List<Transaction> get _recentTransaction {
    return _transactions.where((transaction) {
      return transaction.date
          .isAfter(DateTime.now().subtract(Duration(days: 10)));
    }).toList();
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build() MyHomePageState');

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _openAddTransactionModal(context),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text('Personal Expenses App'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _openAddTransactionModal(context);
                },
              ),
            ],
          );

    Widget _transactionList(heightRatio) {
      return Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            heightRatio,
        child: TransactionList(
          _transactions.reversed.toList(),
          _deleteTransaction,
        ),
      );
    }

    Widget _transactionChart(heightRatio) {
      return Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            heightRatio,
        child: Chart(_recentTransaction),
      );
    }

    bool isLandscaped() {
      return MediaQuery.of(context).orientation == Orientation.landscape;
    }

    final appBody = SafeArea(
      child: SingleChildScrollView(
        child: !isLandscaped()
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [_transactionChart(0.3), _transactionList(0.7)],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Show Chart',
                        style: Theme.of(context).textTheme.title,
                      ),
                      Switch(
                          value: _showChart,
                          onChanged: (showChart) {
                            setState(() {
                              _showChart = showChart;
                            });
                          }),
                    ],
                  ),
                  _showChart ? _transactionChart(0.7) : _transactionList(0.7)
                ],
              ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: appBody,
            navigationBar: appBar,
          )
        : Container(
            child: Scaffold(
              appBar: appBar,
              body: appBody,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Platform.isIOS
                  ? Container()
                  : FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        return _openAddTransactionModal(context);
                      },
                    ),
            ),
          );
  }
}
