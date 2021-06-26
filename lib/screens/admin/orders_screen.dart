import 'package:buyit/models/order.dart';
import 'package:buyit/screens/admin/order_details.dart';
import 'package:buyit/services/store.dart';
import 'package:buyit/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  static String id = 'OrdersScreen';
  final Store _store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('There is No orders'),
            );
          }
          List<Order> orders = [];
          for (var doc in snapshot.data.docs) {
            orders.add(Order(
                docId: doc.id,
                totalPrice: doc[KTotalPrice],
                address: doc[KAddress]));
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(top: 12, right: 16, left: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, OrderDetails.id,
                        arguments: orders[index].docId);
                  },
                  child: Card(
                    elevation: 5,
                    child: ListTile(
                      title: Text(
                          'Total Price: \$ ${orders[index].totalPrice.toString()}'),
                      subtitle: Text('Address: ${orders[index].address}'),
                      trailing: Text(
                        'Show details...',
                        style: TextStyle(color: KMainColor),
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: orders.length,
          );
        },
      ),
    );
  }
}
