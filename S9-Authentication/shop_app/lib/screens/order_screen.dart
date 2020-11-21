import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' as o;
import '../providers/auth.dart';
import './auth_screen.dart';
import '../widgets/order_item.dart';
import '../widgets/error_snackbar.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    return new Scaffold(
      body: new RefreshIndicator(
        onRefresh: () async =>
            await Provider.of<o.Orders>(context, listen: false)
                .fetchOrdersData()
                .catchError((_) {
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(
            new ErrorSnackbar(context).showErrorSnackBar(),
          );
        }),
        child: !auth.isAuth
            ? Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('You are not login yet. Please login first.'),
                    const SizedBox(
                      height: 4,
                    ),
                    new RaisedButton(
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed(AuthScreen.routeName),
                        color: Theme.of(context).accentColor,
                        child: const Text(
                          'Login',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ))
                  ],
                ),
              )
            : new Consumer<o.Orders>(
                builder: (context, loadedOrders, child) => new ListView.builder(
                  itemCount: loadedOrders.orders.length,
                  itemBuilder: (context, index) => new OrderItem(
                    orderDatetime: loadedOrders.orders[index].dateTime,
                    orderAmount: loadedOrders.orders[index].amount,
                    orderCartList: loadedOrders.orders[index].cartList,
                  ),
                ),
              ),
      ),
    );
  }
}
