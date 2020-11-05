import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' as o;
import '../widgets/order_item.dart';
import '../widgets/error_snackbar.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new RefreshIndicator(
        onRefresh: () async =>
            await Provider.of<o.Orders>(context, listen: false)
                .fetchOrdersData()
                .catchError((_) {
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(
            new ErrorSnackbar(context: context).showSnackBar(),
          );
        }),
        child: new Consumer<o.Orders>(
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
