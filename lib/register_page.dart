import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:registration/home_page.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  final emailTextEditController = new TextEditingController();
  final firstNameTextEditController = new TextEditingController();
  final lastNameTextEditController = new TextEditingController();
  final passwordTextEditController = new TextEditingController();
  final confirmPasswordTextEditController = new TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: new EdgeInsets.all(25.0),
        child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 36.0, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email.';
                      }
                    },
                    controller: emailTextEditController,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    controller: firstNameTextEditController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your first name.';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'First Name',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    controller: lastNameTextEditController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your last name.';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    autofocus: false,
                    obscureText: true,
                    controller: passwordTextEditController,
                    validator: (value) {
                      if (value.length < 8) {
                        return 'Password must be longer than 8 characters.';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    autofocus: false,
                    obscureText: true,
                    controller: confirmPasswordTextEditController,
                    validator: (value) {
                      if (passwordTextEditController.text.length > 8 && passwordTextEditController.text !=value) {
                        return 'Passwords do not match.';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top:10.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _firebaseAuth.createUserWithEmailAndPassword(email: emailTextEditController.text, password:passwordTextEditController.text).then((onValue) {
                          Firestore.instance.collection('users').document(onValue.uid).setData({
                            'firstName': firstNameTextEditController.text,
                            'lastName': lastNameTextEditController.text,
                          }).then((userInfoValue) {
                            Navigator.of(context).pushNamed(HomePage.tag);
                          });
                        }).catchError((onError) {
                          print(onError);
                        });
                      }
                    },
                    padding: EdgeInsets.all(12),
                    color: Colors.lightGreen,
                    child: Text('Sign Up'.toUpperCase(),
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.zero,
                  child: FlatButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black54),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                )
              ],
            )
          )
        ),
    );
  }
}
