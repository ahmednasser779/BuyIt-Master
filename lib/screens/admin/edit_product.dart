import 'package:buyit/models/product.dart';
import 'package:buyit/services/store.dart';
import 'package:buyit/shared/constants.dart';
import 'package:buyit/shared/custom_fields.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditProduct extends StatelessWidget {
  static String id = 'EditProduct';
  final _globalKey = GlobalKey<FormState>();
  String _name, _price, _desc, _category, _image;
  final _store = Store();

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: KMainColor,
      body: SafeArea(
        child: Form(
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
                    initialValue: product.pName,
                  ),
                  ProductTextField(
                    hint: 'Product Price',
                    onSaved: (value) {
                      _price = value;
                    },
                    initialValue: product.pPrice,
                  ),
                  ProductTextField(
                    hint: 'Product Description',
                    onSaved: (value) {
                      _desc = value;
                    },
                    initialValue: product.pDescription,
                  ),
                  ProductTextField(
                    hint: 'Product Category',
                    onSaved: (value) {
                      _category = value;
                    },
                    initialValue: product.pCategory,
                  ),
                  ProductTextField(
                    hint: 'Product Image location',
                    onSaved: (value) {
                      _image = value;
                    },
                    initialValue: product.pLocation,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      if (_globalKey.currentState.validate()) {
                        _globalKey.currentState.save();
                        await _store.editProduct({
                          KProductName: _name,
                          KProductPrice: _price,
                          KProductDesc: _desc,
                          KProductCategory: _category,
                          KProductLocation: _image
                        }, product.pId);
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text('Editing Success'),
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
                      'Edit Product',
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
      ),
    );
  }
}
