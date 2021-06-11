import 'package:appentus_app/logic/models/user.dart';
import 'package:appentus_app/logic/services/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _globalkey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  Controller controller = Controller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Form(
        key: _globalkey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
          ],
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
      decoration: InputDecoration(hintText: "Enter $name"),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_globalkey.currentState.validate()) {

            Map map = await controller.login(new User(
                id: null,
                name: null,
                email: _email.text,
                image: null,
                number: null,
                password: _password.text));

            if (map==null || map.isEmpty) {
              print('Invalid Credentials');
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Invalid Credentials. Please enter again.')));
            } else {
              print("User Successfully Logged In");
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Welcome')));
              Navigator.pushNamed(context, '/home', arguments: User.fromJson(map));
            }
          }
        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(top: 12, left: 30, right: 30, bottom: 12),
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
      ),
    );
  }
}
