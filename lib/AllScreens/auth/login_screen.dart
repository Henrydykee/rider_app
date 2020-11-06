import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/AllScreens/auth/signup_screen.dart';
import 'package:rider_app/AllScreens/home/home_screen.dart';
import 'package:rider_app/widget/button.dart';
import 'package:rider_app/widget/progress_dialog.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _emailController;
  TextEditingController _passwordController;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    _emailController = TextEditingController();
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
              Image(image: AssetImage("assets/images/logo.png"),
                width: MediaQuery.of(context).size.width,
                height: 120,
                alignment: Alignment.center,
              ),
              SizedBox(height: 20.0),
              Text("Login as a rider",textAlign: TextAlign.center ,style: TextStyle(
                fontSize: 24,
              ),),
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
                title: "Login",
                onTap: (){
                  if(!_emailController.text.contains("@")){
                    Fluttertoast.showToast(
                        msg: "Invalid email",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16.0
                    );
                  } else if (_passwordController.text.length < 6 ){
                    Fluttertoast.showToast(
                        msg: "Password cannot be less than 6 characters",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16.0
                    );
                  } else{
                    loginandAuthUser(context);
                  }
                },
                color: Colors.black,
              ),
              SizedBox(height: 50.0),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: Text("Don't have an Account? ",textAlign: TextAlign.center ,style: TextStyle(
                  fontSize: 14,
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void loginandAuthUser(BuildContext context) async {

    showDialog(
        context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
         return ProgressDialog(message: "Logging In...",);
      }
    );


    User firebaseUser = (await _firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text
    ).catchError((err){
      Navigator.of(context).pop();
      log("$err");
      Fluttertoast.showToast(
          msg: "$err",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
      );
    })).user;

    if(firebaseUser != null) {
      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap){
        if(snap != null){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              HomeScreen()), (Route<dynamic> route) => false);
        } else{
          _firebaseAuth.signOut();
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "Invalid Credentials",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              fontSize: 16.0
          );
        }
      });

    }else{
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Error Occurred",
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
