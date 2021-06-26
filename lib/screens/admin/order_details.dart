import 'package:buyit/models/product.dart';
import 'package:buyit/services/store.dart';
import 'package:buyit/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatelessWidget {
  static String id = 'OrderDetails';
  final Store _store = Store();

  @override
  Widget build(BuildContext context) {
    final String docId = ModalRoute
        .of(context)
        .settings
        .arguments;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: _store.loadOrderDetails(docId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<Product> products = [];
            for (var doc in snapshot.data.docs) {
              products.add(Product(
                  pName: doc[KProductName],
                  pLocation: doc[KProductLocation],
                  pCategory: doc[KProductCategory],
                  pDescription: doc[KProductDesc],
                  pPrice: doc[KProductPrice],
                  pQuantity: doc[KProductQuantity]
              ));
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(top: 12, right: 16, left: 16),
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                              AssetImage(products[index].pLocation),
                              radius: 30,
                            ),
                            title: Text(products[index].pDescription),
                            subtitle: Text('\$ ${products[index].pPrice}'),
                            trailing: products[index].pQuantity == 1
                                ? Text(
                                '${products[index].pQuantity.toString()} Piece')
                                : Text(
                                '${products[index].pQuantity.toString()} Pieces'),
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data.docs.length,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: RaisedButton(
                            onPressed: (){},
                            child: Text('Confirm Orders'),
                            color: KMainColor,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: RaisedButton(
                            onPressed: (){},
                            child: Text('Delete Orders'),
                            color: KMainColor,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}
