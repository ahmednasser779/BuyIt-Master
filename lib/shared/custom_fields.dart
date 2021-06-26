import 'package:buyit/shared/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Function onSaved;

  CustomTextField({@required this.hint, @required this.icon, @required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return _errorMessage(hint);
          }
          return null;
        },
        onSaved: onSaved,
        obscureText: hint == 'Enter your password' ? true : false,
        cursorColor: KMainColor,
        decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: KMainColor),
            filled: true,
            fillColor: KSecondaryColor,
            enabledBorder: customOutlineBorder(),
            focusedBorder: customOutlineBorder(),
            border: customOutlineBorder()),
      ),
    );
  }

  String _errorMessage(String hintTxt) {
    switch (hintTxt) {
      case 'Enter your name':
        return 'Your name is empty !';
      case 'Enter your email':
        return 'Your email is empty !';
      case 'Enter your password':
        return 'Your password is empty !';
    }
    return null;
  }
}

OutlineInputBorder customOutlineBorder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.white));
}

class ProductTextField extends StatelessWidget {
  final String hint;
  final Function onSaved;
  final String initialValue;

  ProductTextField({@required this.hint,@required this.onSaved, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: TextFormField(
        validator: (value){
          if (value.isEmpty){
            return 'Required Field!';
          }
          return null;
        },
        onSaved: onSaved,
        initialValue: initialValue?? '',
        decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: KSecondaryColor,
            enabledBorder: customOutlineBorder(),
            focusedBorder: customOutlineBorder(),
            border: customOutlineBorder()),
      ),
    );
  }
}

