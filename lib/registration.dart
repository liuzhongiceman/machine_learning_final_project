import 'package:flutter/material.dart';
import 'package:garage_sale_neu_sv/post.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Registration extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  void _signUp () async{
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (newUser != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Post()));
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          color: Colors.red,
          image: DecorationImage(
              image: AssetImage('images/bg.jpeg'), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FlatButton(
                child: Image.asset("images/back-arrow.png"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              SizedBox(
                height: 24.0,
              ),
              TextField(
                style: new TextStyle(color: Colors.white),
                onChanged: (v) {
                  email = v;
                },
                decoration: InputDecoration(
                    hintText: "Type Email Address",
                    hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.white)
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              TextField(
                style: new TextStyle(color: Colors.white),
                onChanged: (v) {
                  password = v;
                },
                decoration: InputDecoration(
                    hintText: "Create Password",
                    hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.white)
                ),
              ),
              SizedBox(
                height: 24.0,
              ),

              new FlatButton(onPressed: _signUp, child: new Text('SIGN-UP', style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20))),
            ],
          ),
        ),
      ),
    );
  }
}
