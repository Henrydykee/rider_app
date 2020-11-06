

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rider_app/AllScreens/home/home_screen.dart';
import 'package:rider_app/main.dart';
import 'package:rider_app/widget/button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/widget/progress_dialog.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _phoneController;
  TextEditingController _passwordController;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              SizedBox(height: 100.0),
              Text(
                "SignUp as a rider",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              loginFields(
                labelText: "Name",
                controller: _nameController,
                keyboardType: TextInputType.name,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return 'This field is required';
                  }
                },
              ),
              SizedBox(height: 20.0),
              loginFields(
                controller: _emailController,
                labelText: "Email Address",
                keyboardType: TextInputType.emailAddress,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return 'This field is required';
                  }
                },
              ),
              SizedBox(height: 20.0),
              loginFields(
                labelText: "Phone",
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return 'This field is required';
                  }
                },
              ),
              SizedBox(height: 20.0),
              loginFields(
                controller: _passwordController,
                labelText: "Password",
                obscureText: true,
                keyboardType: TextInputType.text,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return 'This field is required';
                  }
                },
              ),
              SizedBox(height: 50.0),
              RiderButtons(
                title: "SignUp",
                onTap: () {
                  if (_nameController.text.length <3 ){
                    Fluttertoast.showToast(
                        msg: "Name cannot be less than three characters",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16.0
                    );
                  }else if (!_emailController.text.contains("@")){
                    Fluttertoast.showToast(
                        msg: "invalid email address",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16.0
                    );
                  }else if (_phoneController.text.isEmpty){
                    Fluttertoast.showToast(
                        msg: "invalid email address",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16.0
                    );
                  }else if (_passwordController.text.length < 6){
                    Fluttertoast.showToast(
                        msg: "Password cannot be less than 6 characters",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16.0
                    );
                  }
                  registerNewUser(context);
                },
                color: Colors.black,
              ),
              SizedBox(height: 50.0),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Have an Account? ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void registerNewUser(BuildContext context) async {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "SignIn Up...",);
        }
    );

    User firebaseUser =
        (await _firebaseAuth.createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text).catchError((err){
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "Email address already exist",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
          );
          log("$err");
        }))
            .user;

    if(firebaseUser != null) {
      //save user to database

      Map userDataMap={
        "name" : _nameController.text.trim(),
        "email" : _emailController.text.trim(),
        "phone" : _phoneController.text.trim(),
       // "password" : _passwordController.text
      };
      usersRef.child(firebaseUser.uid).set(userDataMap);

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          HomeScreen()), (Route<dynamic> route) => false);

    }else{
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "User is not saved to database",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0
      );
    }
  }

}





class loginFields extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final Widget prefix;
  final FocusNode currentFocusNode;
  final FocusNode nextFocusNode;
  final String labelText;
  final Function validator;
  final bool obscureText;

  loginFields(
      {this.controller,
      this.currentFocusNode,
      this.nextFocusNode,
      this.prefix,
      this.labelText,
      this.inputFormatters,
      this.keyboardType,
      this.obscureText = false,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // ignore: missing_return
      validator: validator,
      focusNode: currentFocusNode,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(nextFocusNode ?? FocusNode());
      },
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      cursorColor: Colors.black,
      inputFormatters: inputFormatters,
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          prefix: prefix,
          labelText: labelText,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            letterSpacing: 0.12,
            color: Colors.grey,
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black))),
    );
  }
}
