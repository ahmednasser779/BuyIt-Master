import 'package:buyit/models/product.dart';
import 'package:buyit/screens/admin/edit_product.dart';
import 'package:buyit/services/store.dart';
import 'package:buyit/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:buyit/shared/custom_widgets.dart';

class ManageProducts extends StatelessWidget {
  static String id = 'ManageProducts';
  final _store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
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
            products.add(Product(
                pName: data[KProductName],
                pPrice: data[KProductPrice],
                pDescription: data[KProductDesc],
                pCategory: data[KProductCategory],
                pLocation: data[KProductLocation],
                pId: doc.id));
          }
          return GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(12),
                child: GestureDetector(
                  onTapUp: (details) {
                    double dx = details.globalPosition.dx;
                    double dy = details.globalPosition.dy;
                    double dx2 = MediaQuery.of(context).size.width - dx;
                    double dy2 = MediaQuery.of(context).size.width - dy;
                    showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
                        items: [
                          MyPopupMenuItem(
                            child: Text('Edit'),
                            onClick: () async{
                             await Navigator.pushNamed(context, EditProduct.id, arguments: products[index]);
                             Navigator.pop(context);
                            },
                          ),
                          MyPopupMenuItem(
                            child: Text('Delete'),
                            onClick: () async{
                              await _store.deleteProduct(products[index].pId);
                              Navigator.pop(context);
                            },
                          )
                        ]);
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
      ),
    );
  }
}
