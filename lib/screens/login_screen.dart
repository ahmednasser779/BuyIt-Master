import 'package:buyit/provider/admin_mode.dart';
import 'package:buyit/provider/model_hud.dart';
import 'package:buyit/screens/signup_screen.dart';
import 'package:buyit/screens/user/home_screen.dart';
import 'package:buyit/services/auth_services.dart';
import 'package:buyit/shared/constants.dart';
import 'package:buyit/shared/custom_fields.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'admin/admin_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String _email, _password;
  final _auth = AuthServices();
  String adminPassword = 'Admin1234';
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    bool isAdmin = Provider.of<AdminMode>(context).isAdmin;
    return Scaffold(
      backgroundColor: KMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHud>(context).isLoading,
        child: Form(
          key: _globalKey,
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
                          style:
                              TextStyle(fontFamily: 'Pacifico', fontSize: 25),
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
                height: height * 0.01,
              ),
              CheckboxListTile(
                value: rememberMe,
                onChanged: (value){
                  setState(() {
                    rememberMe = value;
                  });
                },
                title: Text('Remember Me'),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 120),
                child: Builder(
                  builder: (context) => FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: () {
                      if(rememberMe){
                        _keepUserLoggedIn();
                      }
                      _validate(context);
                    },
                    color: Colors.black,
                    child: Text(
                      'Login',
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
                      'Don\'t have an account ? ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SignUpScreen.id);
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          Provider.of<AdminMode>(context, listen: false)
                              .changeIsAdmin(true);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          'Admin',
                          style: TextStyle(
                              color: isAdmin ? Colors.black : Colors.white),
                        ),
                        color: isAdmin ? Colors.grey : Colors.black,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          Provider.of<AdminMode>(context, listen: false)
                              .changeIsAdmin(false);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          'User',
                          style: TextStyle(
                              color: isAdmin ? Colors.white : Colors.black),
                        ),
                        color: isAdmin ? Colors.black : Colors.grey,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _validate(BuildContext context) async {
    final modelHud = Provider.of<ModelHud>(context, listen: false);
    modelHud.isLoadingChange(true);
    if (_globalKey.currentState.validate()) {
      _globalKey.currentState.save();
      if (Provider.of<AdminMode>(context, listen: false).isAdmin) {
        if(_password == adminPassword){
          try {
            await _auth.login(_email.trim(), _password.trim());
            Navigator.pushNamed(context, AdminHome.id);
          } catch (e) {
            print(e.toString());
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
          }
        }else{
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Something went wrong!')));
        }
      }
      else {
        try {
          await _auth.login(_email, _password);
          Navigator.pushNamed(context, HomeScreen.id);
        } catch (e) {
          print(e.toString());
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
        }
      }
    }
    modelHud.isLoadingChange(false);
  }

  _keepUserLoggedIn() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(kRememberUser, rememberMe);
  }
}
