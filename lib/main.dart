import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/consts/theme_data_my.dart';
import 'package:grocery_app/fetch_screen.dart';
import 'package:grocery_app/inner_screen/cat_screen.dart';
import 'package:grocery_app/inner_screen/feeds_screen.dart';
import 'package:grocery_app/inner_screen/on_sale_screen.dart';
import 'package:grocery_app/inner_screen/product_detail.dart';
import 'package:grocery_app/provider/dark_them_provider.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/orders_provider.dart';
import 'package:grocery_app/providers/product_providers.dart';
import 'package:grocery_app/providers/viewed_prod_provider.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/screens/auth/forget_password.dart';
import 'package:grocery_app/screens/auth/rigister_screen.dart';
import 'package:grocery_app/screens/auth/login_screen.dart';
import 'package:grocery_app/screens/order/order_screen.dart';
import 'package:grocery_app/screens/viewed_recently/viewed_recently.dart';
import 'package:grocery_app/screens/whishlist/wish_list_screen.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentThem() async {
    themeChangeProvider.setDarkThem =
        await themeChangeProvider.darkThemePrefs.getThem();
  }

  @override
  void initState() {
    getCurrentThem();
    super.initState();
  }
         final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context,snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),

          );
        }else if(snapshot.hasError){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text('Error occurred'),
              ),
            ),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => themeChangeProvider),
            ChangeNotifierProvider(create: (_) => ProductsProvider()),
            // ChangeNotifierProvider(create: (_)=> ProductDetail()),
            ChangeNotifierProvider(create: (_) => CartProvider()),
            ChangeNotifierProvider(create: (_) => WishlistProvider()),
            ChangeNotifierProvider(create: (_) => ViewedProdProvider()),
            ChangeNotifierProvider(create: (_) => OrdersProvider()),
          ],
          child:
              Consumer<DarkThemeProvider>(builder: (context, themeProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: Styles.themeData(themeProvider.getDarkTheme, context),
              home: const FetchScreen(),
              routes: {
                OnSaleScreen.routeName: (_) => OnSaleScreen(),
                FeedsScreen.routeName: (_) => FeedsScreen(),
                ProductDetails.routeName: (_) => ProductDetails(),
                WishlistScreen.routeName: (_) => WishlistScreen(),
                OrdersScreen.routeName: (_) => OrdersScreen(),
                ViewedScreen.routeName: (_) => ViewedScreen(),
                RegisterScreen.routeName: (_) => RegisterScreen(),
                LoginScreen.routeName: (_) => LoginScreen(),
                ForgetPasswordScreen.routeName: (_) => ForgetPasswordScreen(),
                CategoryScreen.routeName: (_) => CategoryScreen(),
              },
            );
          }),
        );
      }
    );
  }
}
