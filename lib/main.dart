import 'package:buyit/provider/admin_mode.dart';
import 'package:buyit/provider/cart_item.dart';
import 'package:buyit/provider/model_hud.dart';
import 'package:buyit/screens/admin/add_product.dart';
import 'package:buyit/screens/admin/admin_home.dart';
import 'package:buyit/screens/admin/edit_product.dart';
import 'package:buyit/screens/admin/manage_products.dart';
import 'package:buyit/screens/admin/order_details.dart';
import 'package:buyit/screens/admin/orders_screen.dart';
import 'package:buyit/screens/login_screen.dart';
import 'package:buyit/screens/signup_screen.dart';
import 'package:buyit/screens/user/cart_screen.dart';
import 'package:buyit/screens/user/home_screen.dart';
import 'package:buyit/screens/user/product_info.dart';
import 'package:buyit/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  bool isUserLoggedIn;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        isUserLoggedIn = snapshot.data.getBool(kRememberUser) ?? false;
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ModelHud()),
            ChangeNotifierProvider(create: (context) => AdminMode()),
            ChangeNotifierProvider(create: (context) => CartItem()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'BuyIt',
            initialRoute: isUserLoggedIn? HomeScreen.id: LoginScreen.id,
            routes: {
              LoginScreen.id: (context) => LoginScreen(),
              SignUpScreen.id: (context) => SignUpScreen(),
              HomeScreen.id: (context) => HomeScreen(),
              AdminHome.id: (context) => AdminHome(),
              AddProduct.id: (context) => AddProduct(),
              ManageProducts.id: (context) => ManageProducts(),
              OrdersScreen.id: (context) => OrdersScreen(),
              EditProduct.id: (context) => EditProduct(),
              ProductInfo.id: (context) => ProductInfo(),
              CartScreen.id: (context) => CartScreen(),
              OrderDetails.id: (context) => OrderDetails(),
            },
            theme: ThemeData(
              primarySwatch: Colors.amber,
              accentColor: Colors.amberAccent
            ),
          ),
        );
      }
    );
  }
}
