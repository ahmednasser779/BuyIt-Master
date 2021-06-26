import 'package:buyit/models/product.dart';
import 'package:buyit/screens/login_screen.dart';
import 'package:buyit/screens/user/product_info.dart';
import 'package:buyit/services/auth_services.dart';
import 'package:buyit/services/store.dart';
import 'package:buyit/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _store = Store();
  final _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: KMainColor,
          bottom: TabBar(
            indicatorColor: KSecondaryColor,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            tabs: [
              Text('Jackets'),
              Text('Trousers'),
              Text('T-Shirts'),
              Text('Shoes'),
            ],
          ),
          title: Text('discover'.toUpperCase(),
              style: TextStyle(
                fontSize: 20,
              )),
          actions: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () => Navigator.pushNamed(context, CartScreen.id),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_){
                        return AlertDialog(
                          title: Text('Are you sure to sign out!'),
                          actions: [
                            FlatButton(
                              onPressed: (){
                                signOut(context);
                              },
                              child: Text('Yes'),
                            )
                          ],
                        );
                      }
                    );
                  },
                ),
              ],
            )
          ],
        ),
        body: TabBarView(
          children: [
            productsView(KJackets),
            productsView(KTrousers),
            productsView(KTShirts),
            productsView(KShoes),
          ],
        ),
      ),
    );
  }

  Widget productsView(String category) {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.loadProducts(),
      builder: (context, snapShot) {
        if (!snapShot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<Product> products = [];
        for (var doc in snapShot.data.docs) {
          var data = doc.data();
          if (doc[KProductCategory] == category) {
            products.add(Product(
                pName: data[KProductName],
                pPrice: data[KProductPrice],
                pDescription: data[KProductDesc],
                pCategory: data[KProductCategory],
                pLocation: data[KProductLocation],
                pId: doc.id));
          }
        }
        return GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(12),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ProductInfo.id,
                      arguments: products[index]);
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage(products[index].pLocation),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Opacity(
                        opacity: 0.8,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  products[index].pDescription,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '\$ ${products[index].pPrice}',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: products.length,
        );
      },
    );
  }

  signOut(BuildContext context) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    await _auth.signOut();
    Navigator.popAndPushNamed(context, LoginScreen.id);
  }
}
