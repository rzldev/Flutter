import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './screens/product_detail_screen.dart';
import './screens/transaction_screen.dart';
import './screens/home_screen.dart';
import './providers/products.dart';
import './providers/carts.dart';
import './providers/orders.dart';
import './screens/edit_user_product_screen.dart';

Future main() async {
  await DotEnv().load('.env');

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
        initialRoute: HomeScreen.routeName,
        routes: {
          HomeScreen.routeName: (context) => new HomeScreen(),
          ProductDetailScreen.routeName: (context) => new ProductDetailScreen(),
          TransactionScreen.routeName: (context) => new TransactionScreen(),
          EditUserProductScreen.routeName: (context) =>
              new EditUserProductScreen(),
        },
      ),
    );
  }
}
