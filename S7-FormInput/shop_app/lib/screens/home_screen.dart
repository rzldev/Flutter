import 'package:flutter/material.dart';

import './products_overview_screen.dart';
import './transaction_screen.dart';
import './user_product_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final _pages = [
    new ProductsOverviewScreen(),
    new TransactionScreen(),
    new UserProductScreen(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            label: 'Transaction',
          ),
          const BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle),
            label: 'User',
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: _onPageChanged,
      ),
    );
  }
}
