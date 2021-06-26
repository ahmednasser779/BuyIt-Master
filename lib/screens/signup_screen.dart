import 'package:buyit/provider/model_hud.dart';
import 'package:buyit/services/auth_services.dart';
import 'package:buyit/shared/constants.dart';
import 'package:buyit/shared/custom_fields.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'user/home_screen.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatelessWidget {
  static String id = 'SignUpScreen';
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String _email, _password;
  final _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: KMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHud>(context).isLoading,
        child: Form(
          key: _key,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: Container(
                  height: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/icons/buyicon.png'),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Text(
                          'BuyIt',
                          style: TextStyle(fontFamily: 'Pacifico', fontSize: 25),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.1,
              ),
              CustomTextField(
                onSaved: (value) {},
                hint: 'Enter your name',
                icon: Icons.mail,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomTextField(
                onSaved: (value) {
                  _email = value;
                },
                hint: 'Enter your email',
                icon: Icons.mail,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomTextField(
                onSaved: (value) {
                  _password = value;
                },
                hint: 'Enter your password',
                icon: Icons.lock,
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 120),
                child: Builder(
                  builder: (context) => FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: () async {
                      final modelHud = Provider.of<ModelHud>(context, listen: false);
                      modelHud.isLoadingChange(true);
                      if (_key.currentState.validate()) {
                        _key.currentState.save();
                        try {
                          await _auth.signUp(_email.trim(), _password.trim());
                          Navigator.pushNamed(context, HomeScreen.id);
                        } catch (e) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(e.message),
                          ));
                        }
                      }
                      modelHud.isLoadingChange(false);
                    },
                    color: Colors.black,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account ? ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
