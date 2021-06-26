import 'package:buyit/models/product.dart';
import 'package:buyit/provider/cart_item.dart';
import 'package:buyit/screens/user/product_info.dart';
import 'package:buyit/services/store.dart';
import 'package:buyit/shared/constants.dart';
import 'package:buyit/shared/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static String id = 'CartScreen';

  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<CartItem>(context).products;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KMainColor,
        title: Text('My Cart'),
        centerTitle: true,
      ),
      body: products.isEmpty
          ? Center(
              child: Text('Your Cart is empty!'),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: EdgeInsets.only(top: 6, right: 6, left: 6),
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
                                      await Navigator.pushNamed(context, ProductInfo.id, arguments: products[index]);
                                      Navigator.pop(context);
                                      Provider.of<CartItem>(context, listen: false).deleteProduct(products[index]);
                                    },
                                  ),
                                  MyPopupMenuItem(
                                    child: Text('Delete'),
                                    onClick: (){
                                      Navigator.pop(context);
                                      Provider.of<CartItem>(context, listen: false).deleteProduct(products[index]);
                                    },
                                  )
                                ]);
                          },
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
                        ),
                      );
                    },
                    itemCount: products.length,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50, bottom: 20),
                    child: Builder(
                      builder: (context) {
                        return ButtonTheme(
                          minWidth: 180,
                          height: 60,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            onPressed: () {
                              showCustomDialog(context, products);
                            },
                            child: Text(
                              'Order',
                              style: TextStyle(fontSize: 18),
                            ),
                            color: KMainColor,
                          ),
                        );
                      }
                    ),
                  )
                ],
              ),
            ),
    );
  }

  showCustomDialog(BuildContext context, List<Product> products) {
    int price = getTotalPrice(products);
    var address;
    AlertDialog alertDialog = AlertDialog(
      title: Text('Total price is \$ $price'),
      content: TextField(
        onChanged: (value){
          address = value;
        },
        decoration: InputDecoration(
          hintText: 'Enter your Address'
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: (){
            try {
              Store _store = Store();
              _store.storeOrders({
                KTotalPrice: price,
                KAddress: address
              },products);
              Navigator.pop(context);
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Ordered Successfully'),
              ));
            }catch(ex){
              print(ex.toString());
            }
          },
          child: Text('Confirm', style: TextStyle(color: KMainColor, fontSize: 18)),
        )
      ],
    );
    showDialog(
      context: context,
      builder: (_){
        return alertDialog;
      }
    );
  }

  getTotalPrice(List<Product> products) {
    int price = 0;
    for(var product in products){
      price += product.pQuantity * int.parse(product.pPrice);
    }
    return price;
  }
}
