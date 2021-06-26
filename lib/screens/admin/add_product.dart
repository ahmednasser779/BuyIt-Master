import 'package:buyit/models/product.dart';
import 'package:buyit/services/store.dart';
import 'package:buyit/shared/constants.dart';
import 'package:buyit/shared/custom_fields.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddProduct extends StatelessWidget {
  static String id = 'AddProduct';
  final _globalKey = GlobalKey<FormState>();
  String _name, _price, _desc, _category, _image;
  final _store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KMainColor,
      body: Form(
        key: _globalKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2, bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProductTextField(
                  hint: 'Product Name',
                  onSaved: (value) {
                    _name = value;
                  },
                ),
                ProductTextField(
                  hint: 'Product Price',
                  onSaved: (value) {
                    _price = value;
                  },
                ),
                ProductTextField(
                  hint: 'Product Description',
                  onSaved: (value) {
                    _desc = value;
                  },
                ),
                ProductTextField(
                  hint: 'Product Category',
                  onSaved: (value) {
                    _category = value;
                  },
                ),
                ProductTextField(
                  hint: 'Product Image location',
                  onSaved: (value) {
                    _image = value;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                RaisedButton(
                  onPressed: () async{
                    if(_globalKey.currentState.validate()){
                      _globalKey.currentState.save();
                      await _store.addProduct(
                        Product(
                          pName: _name,
                          pPrice: _price,
                          pDescription: _desc,
                          pCategory: _category,
                          pLocation: _image
                        )
                      );
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text('Adding Success'),
                              content: Text(
                                  'Your data have been uploaded successfully...'),
                              actions: [
                                FlatButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Ok'),
                                )
                              ],
                            );
                          });
                    }
                  },
                  child: Text(
                    'Add Product',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
