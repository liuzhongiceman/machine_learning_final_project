import 'package:flutter/material.dart';
import 'package:garage_sale_neu_sv/itemlist.dart';
import 'package:garage_sale_neu_sv/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garage Sale',
      home: Welcome(),
    );
  }
}

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final _auth = FirebaseAuth.instance;
  String errMsg = '';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String password;
  String email;

  void _logIn()async{
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        print('logged in');
        Navigator.push(context, MaterialPageRoute(builder: (context) => ItemList()));
      }
    } catch (e) {
      setState(() {
        errMsg ='Username or password not right, please check';
      });
      print(e);
    }
  }

  void __signUp() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));
  }

  Widget _textInput(String type, String content) {
    return TextField(
      obscureText: type == 'password' ? true : false,
      onChanged: (v) {
          if (type == 'email') {
            email = v;
          } else {
            password = v;
          }
      },
      style: new TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: content,
          hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.white)
      ),
    );
  }



  Widget _flatBtn(String content, Function function) {
    return new FlatButton(onPressed: function, child: new Text(content, style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20)));
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
              image: AssetImage('images/bg.jpeg'),
              fit: BoxFit.cover),),
        child:  Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(errMsg, textAlign: TextAlign.center),
                  SizedBox(
                    height: 14.0,
                  ),
                  _textInput('email',"Input Your Email"),
                  SizedBox(
                    height: 14.0,
                  ),
                  _textInput('password',"Input Your Password"),

                  SizedBox(
                    height: 14.0,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _flatBtn('LOG IN',_logIn ),
                        _flatBtn('SIGN UP', __signUp),
                      ]
                  )]
            )
        ),
      ),

    );
  }
}


