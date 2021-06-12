
import 'package:appentus_app/logic/models/user.dart';
import 'package:appentus_app/logic/services/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  Controller _controller = Controller();
  final _globalkey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/login_icon.png",
                          height: 38,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 28.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                            child: AnimatedTextKit(
                              isRepeatingAnimation: true,
                              repeatForever: true,
                              animatedTexts: [
                                TypewriterAnimatedText('Hey Welcome BACK!!'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Form(
                  key: _globalkey,
                  child: ListView(
                    shrinkWrap: true,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    children: <Widget>[
                      _buildTF("Email", _email),
                      SizedBox(
                        height: 20,
                      ),
                      _buildTF("Password", _password),
                      SizedBox(
                        height: 20,
                      ),
                      _buildLoginBtn(),
                      _buildSignupBtn(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTF(String name, TextEditingController _cntrl) {
    return TextFormField(
      controller: _cntrl,
      validator: (value) {
        if (value.isEmpty) return "$name can't be empty";
        return null;
      },
      decoration: InputDecoration(
        hintText: "Enter $name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            const Radius.circular(15.0),
          ),
          borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25.0),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            if (_globalkey.currentState.validate()) {
              Map map = await _controller.login(new User(
                  id: null,
                  name: null,
                  email: _email.text,
                  image: null,
                  number: null,
                  password: _password.text));

              if (map == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Email or Password is incorrect')));
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Logged in Successfully')));
                Navigator.pushReplacementNamed(context, '/home',
                    arguments: User.fromJson(map));
              }
            }
          },
          style: ElevatedButton.styleFrom(
              padding:
              EdgeInsets.only(top: 12, left: 30, right: 30, bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              primary: Colors.black,
              elevation: 5.0),
          child: Text(
            'LOGIN',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }

  Widget _buildSignupBtn() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25.0),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/signup');
          },
          style: ElevatedButton.styleFrom(
              padding:
              EdgeInsets.only(top: 12, left: 30, right: 30, bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              primary: Colors.black,
              elevation: 5.0),
          child: Text(
            'SIGNUP',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }
}