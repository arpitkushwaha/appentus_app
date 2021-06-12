import 'dart:io';

import 'package:appentus_app/logic/models/user.dart';
import 'package:appentus_app/logic/services/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key key}) : super(key: key);

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {

  Controller _controller = Controller();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _number = TextEditingController();
  PickedFile _userImageFile;
  final ImagePicker _imagePick = ImagePicker();
  final _globalkey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _globalkey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            children: <Widget>[
              userImage(),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  'Signup',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _buildTF("Name", _name),
              SizedBox(
                height: 20,
              ),
              _buildTF("Email", _email),
              SizedBox(
                height: 20,
              ),
              _buildTF("Password", _password),
              SizedBox(
                height: 20,
              ),
              _buildTF("Number", _number),
              SizedBox(
                height: 20,
              ),
              _buildSignupBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget userImage() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 50.0,
          backgroundImage: _userImageFile == null
              ? AssetImage("assets/images/man.png")
              : FileImage(File(_userImageFile.path)),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose photo from",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera,),
              onPressed: () {
                takeImageFromCamera(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            SizedBox(
              width: 30,
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takeImageFromCamera(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takeImageFromCamera(ImageSource source) async {
    final pickedFile = await _imagePick.getImage(
      source: source,
    );
    setState(() {
      if (pickedFile != null) _userImageFile = pickedFile;
      Navigator.pop(context);
    });
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

  Widget _buildSignupBtn() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_globalkey.currentState.validate()) {

            if(_userImageFile==null)
            {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Image must be selected')));
              return;
            }

            User user = User(
                id: null,
                name: _name.text,
                email: _email.text,
                image: _userImageFile.path,
                number: _number.text,
                password: _password.text);

            int flag = await _controller.signup(user);
            if (flag == 0) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('This email is already registered')));
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Registration Completed Successfully')));
              Navigator.pop(context);
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
          'SIGN UP',
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

