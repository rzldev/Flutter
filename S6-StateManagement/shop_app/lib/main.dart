import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
// import './screens/cart_screen.dart';
// import './screens/order_screen.dart';
import './screens/transaction_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/order.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  // //Set the fit size (fill in the screen size of the device in the design) If the design is based on the size of the iPhone6 ​​(iPhone6 ​​750*1334)
  // ScreenUtil.init(designSize: Size(750, 1334), allowFontScaling: false);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(new SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));

    return new MultiProvider(
      providers: [
        new ChangeNotifierProvider(create: (context) => new Products()),
        new ChangeNotifierProvider(create: (context) => new Cart()),
        new ChangeNotifierProvider(create: (context) => new Orders())
      ],
      child: new MaterialApp(
        title: 'Shop App',
        theme: new ThemeData(
          primarySwatch: Colors.purple,
          primaryColor: Colors.white,
          primaryTextTheme: new TextTheme(
            title:
                new TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          accentColor: Colors.pink,
          fontFamily: 'Lato',
          textTheme: new TextTheme(
            title: new TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            body1: new TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        initialRoute: ProductsOverviewScreen.routeName,
        routes: {
          ProductsOverviewScreen.routeName: (context) =>
              new ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (context) => new ProductDetailScreen(),
          // CartScreen.routeName: (context) => CartScreen(),
          // OrderScreen.routeName: (context) => OrderScreen(),
          TransactionScreen.routeName: (context) => new TransactionScreen(),
        },
      ),
    );
  }
}
