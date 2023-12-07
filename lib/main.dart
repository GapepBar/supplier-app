import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gbim_supplier/Screens/homeppageScreen.dart';
import 'package:gbim_supplier/Screens/loginScreen.dart';
import 'package:gbim_supplier/Screens/orderSuccessScreen.dart';
import 'package:gbim_supplier/Screens/orderSummaryScreen.dart';
import 'package:gbim_supplier/Screens/previewOrder.dart';
import 'package:gbim_supplier/Screens/profileScreen.dart';
import 'package:gbim_supplier/Screens/yourDelivererdOrdersScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/orderplaceScreen.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
        debugShowCheckedModeBanner: false,
        // home: const IntroAnimationScreen(),
        // initialRoute: '/',
        routes: {
          '/homepage': (context) => HomepageScreen(),
          '/loginpage': (context) => LoginScreen(),
          '/profilepage': (context) => ProfileScreen(),
          '/orderplaceScreen': (context) => OrderPlaceScreen(),
          '/previewOrderScreen': (context) => PreviewOrderScreen(),
          '/orderSuccessScreen': (context) => OrderSuccessScreen(),
          '/yourDeliveredOrderScreen': (context) => YourDeliveredOrder(),
          '/orderSummaryScreen': (context) => OrderSummaryScreen(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = (prefs.getString('userId'));

    if (userId != null) {
      return '/category';
    } else {
      return '/loginScreen';
    }
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //     future: checkFirstSeen(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       } else {
    //         if (snapshot.data == '/loginScreen') {
    //           return const LoginScreen();
    //         } else {
    //           return CategoryScreen();
    //         }
    //       }
    //     });

    return HomepageScreen();
    // return LoginScreen();
  }
}
