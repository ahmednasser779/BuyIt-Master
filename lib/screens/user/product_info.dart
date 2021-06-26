import 'package:buyit/models/product.dart';
import 'package:buyit/provider/cart_item.dart';
import 'package:buyit/screens/user/cart_screen.dart';
import 'package:buyit/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductInfo extends StatefulWidget {
  static String id = 'ProductInfo';

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KMainColor,
        title: Text('Details'.toUpperCase()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, CartScreen.id),
          )
        ],
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: Image(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  fit: BoxFit.fill,
                  image: AssetImage(product.pLocation),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24, left: 24),
                child: Text(
                  product.pDescription,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12, left: 24),
                child: Text(
                  '\$ ${product.pPrice}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12, left: 24),
                child: Text(
                  'This is Product Description.This is Product Description.This is Product Description.This is Product Description.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: subtract,
                    child: CircleAvatar(
                      backgroundColor: KMainColor,
                      radius: 20,
                      child: Icon(
                        Icons.remove,
                        color: Colors.black,
                      ),
                    )),
                SizedBox(width: 8),
                Text(
                  _quantity.toString(),
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
                SizedBox(width: 8),
                GestureDetector(
                    onTap: add,
                    child: CircleAvatar(
                      backgroundColor: KMainColor,
                      radius: 20,
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    )),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50, right: 12, left: 12),
            child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                height: 60,
                child: Builder(
                  builder: (context) {
                    return RaisedButton(
                      onPressed: () {
                        addToCart(context, product);
                      },
                      child: Text('Add to cart'.toUpperCase(),
                          style: TextStyle(fontSize: 18)),
                      color: KMainColor,
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }

  add() {
    setState(() {
      _quantity++;
    });
  }

  subtract() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  addToCart(BuildContext context, Product product) {
    CartItem cartItem = Provider.of<CartItem>(context, listen: false);
    var productsInCart = cartItem.products;
    for (var productInCart in productsInCart) {
      if (productInCart.pName == product.pName) {
        cartItem.changeIsExist(true);
      }
      else{
        cartItem.changeIsExist(false);
      }
    }
    if (cartItem.isProductExist) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('This product already exists in your cart!'),
      ));
    } else {
      product.pQuantity = _quantity;
      cartItem.addProduct(product);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Added to cart'),
      ));
    }
    print(cartItem.isProductExist);
  }
}
