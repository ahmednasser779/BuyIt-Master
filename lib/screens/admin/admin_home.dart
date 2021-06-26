import 'package:buyit/screens/admin/add_product.dart';
import 'package:buyit/screens/admin/manage_products.dart';
import 'package:buyit/screens/admin/orders_screen.dart';
import 'package:buyit/shared/constants.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatelessWidget {
  static String id = 'AdminHome';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KMainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
          ),
          _CustomAdminBtn(text: 'Add Product', pageId: AddProduct.id),
          _CustomAdminBtn(text: 'Edit Product', pageId: ManageProducts.id,),
          _CustomAdminBtn(text: 'View Orders', pageId: OrdersScreen.id,)
        ],
      ),
    );
  }
}

class _CustomAdminBtn extends StatelessWidget {
  final String text;
  final String pageId;

  _CustomAdminBtn({this.text, this.pageId});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: (){
        Navigator.pushNamed(context, pageId);
      },
      child: Text(text, style: TextStyle(color: Colors.white),),
      color: Colors.black,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
    );
  }
}
