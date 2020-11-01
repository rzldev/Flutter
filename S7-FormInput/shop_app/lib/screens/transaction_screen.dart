import 'package:flutter/material.dart';

import './cart_screen.dart';
import './order_screen.dart';

class TransactionScreen extends StatefulWidget {
  static const routeName = '/transaction';

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    tabController = new TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Transaction'),
        bottom: new TabBar(
          controller: tabController,
          tabs: [
            new Tab(text: 'Cart'),
            new Tab(text: 'Order'),
          ],
          labelColor: Theme.of(context).accentColor,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelColor: Colors.grey,
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: new TabBarView(controller: tabController, children: [
        new CartScreen(
          tabController: tabController,
          id: id,
        ),
        new OrderScreen(),
      ]),
    );
  }
}
