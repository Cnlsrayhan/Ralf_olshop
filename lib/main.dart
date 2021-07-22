import 'dart:ffi';

import 'package:app_store/inner_screens/brands_navigation_rail.dart';
import 'package:app_store/inner_screens/categories_feeds.dart';
import 'package:app_store/inner_screens/product_details.dart';
import 'package:app_store/provider/orders_provider.dart';
import 'package:app_store/screen/auth/forget_password.dart';
import 'package:app_store/screen/orders/order.dart';
import 'package:app_store/screen/upload_product_form.dart';
import 'package:app_store/provider/cart_provider.dart';
import 'package:app_store/provider/favs_provider.dart';
import 'package:app_store/provider/products.dart';
import 'package:app_store/screen/auth/login.dart';
import 'package:app_store/screen/auth/sign_up.dart';
import 'package:app_store/screen/bottom_bar.dart';
import 'package:app_store/consts/theme_data.dart';
import 'package:app_store/provider/dark_theme_provider.dart';
import 'package:app_store/screen/cart/cart.dart';
import 'package:app_store/screen/feeds.dart';
import 'package:app_store/screen/landing_page.dart';
import 'package:app_store/screen/main_screen.dart';
import 'package:app_store/screen/user_state.dart';
import 'package:app_store/screen/wishlist/wishlist.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text('Error Occured'),
                ),
              ),
            );
          }
          return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) {
                  return themeChangeProvider;
                }),
                ChangeNotifierProvider(
                  create: (_) => Products(),
                ),
                ChangeNotifierProvider(
                  create: (_) => CartProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => FavsProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => OrdersProvider(),
                )
              ],
              child: Consumer<DarkThemeProvider>(
                  builder: (context, themeData, child) {
                return MaterialApp(
                  title: 'Bottom Navigation Bar',
                  theme:
                      Styles.themeData(themeChangeProvider.darkTheme, context),
                  home: Userstate(),
                  routes: {
                    BrandNavigationRailScreen.routeName: (ctx) =>
                        BrandNavigationRailScreen(),
                    CartScreen.routeName: (ctx) => CartScreen(),
                    FeedsScreen.routeName: (ctx) => FeedsScreen(),
                    WishlistScreen.routeName: (ctx) => WishlistScreen(),
                    ProductDetails.routeName: (ctx) => ProductDetails(),
                    CategoriesFeedsScreen.routeName: (ctx) =>
                        CategoriesFeedsScreen(),
                    LoginScreen.routeName: (ctx) => LoginScreen(),
                    SignUpScreen.routeName: (ctx) => SignUpScreen(),
                    BottomBarScreen.routeName: (ctx) => BottomBarScreen(),
                    UploadProductForm.routeName: (ctx) => UploadProductForm(),
                    ForgetPassword.routeName: (ctx) => ForgetPassword(),
                    OrderScreen.routeName: (ctx) => OrderScreen(),
                  },
                );
              }));
        });
  }
}
