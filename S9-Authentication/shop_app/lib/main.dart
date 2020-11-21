import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './providers/products.dart';
import './providers/carts.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './screens/home_screen.dart';
import './screens/auth_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/transaction_screen.dart';
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
          new ChangeNotifierProvider(create: (context) => new Auth()),
          new ChangeNotifierProxyProvider<Auth, Products>(
              create: (context) => new Products(null, null),
              update: (_, auth, previousProducts) =>
                  new Products(auth.token, auth.userId)),
          new ChangeNotifierProvider(create: (context) => new Cart()),
          new ChangeNotifierProxyProvider<Auth, Orders>(
              create: (context) => new Orders([],
                  Provider.of<Auth>(context, listen: false).token,
                  Provider.of<Auth>(context, listen: false).userId),
              update: (_, auth, previousOrders) =>
                  new Orders(previousOrders.orders, auth.token, auth.userId)),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => new MaterialApp(
            title: 'Shop App',
            theme: new ThemeData(
              primarySwatch: Colors.purple,
              primaryColor: Colors.white,
              primaryTextTheme: new TextTheme(
                title: new TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
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
            home: auth.isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (context, authSnapshot) =>
                        authSnapshot.connectionState == ConnectionState.waiting
                            ? Scaffold(
                                body: Center(
                                  child: Text('Loading'),
                                ),
                              )
                            : AuthScreen(),
                  ),
            routes: {
              AuthScreen.routeName: (contect) => new AuthScreen(),
              HomeScreen.routeName: (context) => new HomeScreen(),
              ProductDetailScreen.routeName: (context) =>
                  new ProductDetailScreen(),
              TransactionScreen.routeName: (context) => new TransactionScreen(),
              EditUserProductScreen.routeName: (context) =>
                  new EditUserProductScreen(),
            },
          ),
        ));
  }
}
