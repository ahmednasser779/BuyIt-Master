import 'package:buyit/models/product.dart';
import 'package:flutter/material.dart';

class CartItem extends ChangeNotifier{
  List<Product> products = [];
  bool isProductExist = false;

  changeIsExist(bool value){
    isProductExist = value;
    notifyListeners();
  }

  addProduct(Product product){
    products.add(product);
    notifyListeners();
  }

  deleteProduct(Product product){
    products.remove(product);
    notifyListeners();
  }
}