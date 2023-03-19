import 'package:flutter/material.dart';
import 'package:fluttergadgetstore/providers/product_providers.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';
import './screens/login_screen.dart';
import './screens/registration_screen.dart';
import './screens/verify_email_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/user_profile_screen.dart';
import './screens/product_details_screen.dart';
import './screens/cart_screen.dart';
import './providers/user_provider.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        initialRoute: HomeScreen.routeName,
        routes: {
          HomeScreen.routeName: (cntxt) => const HomeScreen(),
          RegistrationScreen.routeName: (cntxt) => const RegistrationScreen(),
          LoginScreen.routeName: (cntxt) => const LoginScreen(),
          VerifyEmailScreen.routeName: (cntxt) => const VerifyEmailScreen(),
          NotesScreen.routeName: (cntxt) => const NotesScreen(),
          ProductDetailsScreen.nameRoute: (cntxt) =>
              const ProductDetailsScreen(),
          CartScreen.routesName: (cntxt) => const CartScreen(),
          OrdersScreen.routeName: (cntxt) => const OrdersScreen(),
          UserProfileScreen.routeName: (cntxt) => const UserProfileScreen(),
        },
      ),
    );
  }
}
