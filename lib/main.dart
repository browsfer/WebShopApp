import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_shop/screens/splash_screen.dart';

import '/providers/products_provider.dart';
import '/providers/cart.dart';
import '/providers/orders.dart';
import '/providers/auth.dart';

import '/screens/edit_product_screen.dart';
import '/screens/orders_screen.dart';
import '/screens/user_products_screen.dart';
import '/screens/product_overview_screen.dart';
import '/screens/product_detail_screen.dart';
import '/screens/cart_screen.dart';
import '/screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, ProductsProvider>(
            create: (ctx) => ProductsProvider('', null, []),
            update: (ctx, auth, previousProducts) => ProductsProvider(
                auth.token, auth.userId, previousProducts!.products),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders('', '', []),
            update: (ctx, auth, previousOrders) => Orders(
                auth.token, auth.userId, previousOrders!.orderedProducts),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Web Shop',
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                color: Color.fromARGB(255, 8, 15, 51),
              ),
              primaryColor: const Color.fromARGB(
                255,
                8,
                15,
                51,
              ),
              fontFamily: 'Lato',
              colorScheme:
                  ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
                secondary: Color.fromARGB(255, 241, 99, 101),
              ),
            ),
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
