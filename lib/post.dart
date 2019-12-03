import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'itemlist.dart';
import 'camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:garage_sale_neu_sv/main.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

TextEditingController titleController = TextEditingController();
TextEditingController priceController = TextEditingController();
TextEditingController descriptionController = TextEditingController();

class Post extends StatefulWidget {
  const Post({Key key, this.imagePath}) : super(key: key);
  final String imagePath;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Post> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final fireStore = Firestore.instance;
  FirebaseUser curUser;
  final _auth = FirebaseAuth.instance;
  String title = "";
  int price = 0;
  String description = "";

  String imageUrl;

  @override
  void initState() {
    super.initState();
    _getCurUserInfo();

    if (widget.imagePath != null) {
      _uploadImageToFireBase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 1.0,
            horizontal: 32.0,
          ),
          child: Column(
            children: [
              padWidgetTitle("Input Item Title"),
              intPadWidget("Input Item Price"),
              padWidgetDes("Input Item description"),

              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    btn(_toCamera ,'Take Photo'),
                    btnPost(),
                  ]
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: widget.imagePath == null
                      ? null
                      : Image.file(
                          File(widget.imagePath),
                          width: 200,
                          height: 200,
                        ),
                ),
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toListView,
        label: Text('Check All Posts'),
        icon: Icon(Icons.check),
        backgroundColor: Colors.pink,
      ),
    );
  }

  Widget padWidgetTitle (String content) {
    return   Padding(
      padding: const EdgeInsets.only(bottom: 1.0),
      child: TextField(
        controller: titleController,
        onChanged: (v) {
            title = v;
        },
        style: new TextStyle(color: Colors.green),
        decoration: InputDecoration(
            hintText: content,
            hintStyle: TextStyle(
                fontWeight: FontWeight.w300, color: Colors.green)),
      ),
    );
  }

  Widget padWidgetDes (String content) {
    return   Padding(
      padding: const EdgeInsets.only(bottom: 1.0),
      child: TextField(
        controller: descriptionController,
        onChanged: (v) {
            description = v;
        },
        style: new TextStyle(color: Colors.green),
        decoration: InputDecoration(
            hintText: content,
            hintStyle: TextStyle(
                fontWeight: FontWeight.w300, color: Colors.green)),
      ),
    );
  }

  Widget btn (Function function, String content) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Builder(
        builder: (context) {
          return RaisedButton(
              onPressed: function,
              color: Colors.green,
              textColor: Colors.white,
              child: Text(content));
        },
      ),
    );
  }

  Widget btnPost() {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Builder(
        builder: (context) {
          return RaisedButton(
            onPressed: () async {
              try {
                _showSnackbar(context);
                fireStore.collection('Posts').add({
                  'user': curUser.email,
                  'title': title,
                  'price': price,
                  'description': description,
                  'image_path': imageUrl,
                });
                titleController.clear();
                priceController.clear();
                descriptionController.clear();
              } catch (e) {
                print(e);
              }
            },
            color: Colors.green,
            textColor: Colors.white,
            child: Text('Sumbit the Post'),
          );
        },
      ),
    );
  }


 Widget appBar () {
   return AppBar(
     title: Text('Hyper Garage Sale'),
     backgroundColor: Colors.green,
     actions: <Widget>[
       FlatButton(
         textColor: Colors.white,
         onPressed: _singOut,
         child: Text("Sign Out"),
       ),
     ],
   );
 }

  Widget intPadWidget (String content) {
    return   Padding(
      padding: const EdgeInsets.only(bottom: 1.0),
      child: TextField(
        controller: priceController,
        onChanged: (v) {
            price = int.parse(v);
        },
        style: new TextStyle(color: Colors.green),
        decoration: InputDecoration(
            hintText: content,
            hintStyle: TextStyle(
                fontWeight: FontWeight.w300, color: Colors.green)),
      ),
    );
  }
  void _toListView() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ItemList()));
  }

  void _singOut() {
    FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome()));
  }

  void _toCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Camera(camera: firstCamera),
        ));
  }

  void _showSnackbar(BuildContext context) {
    final scaff = Scaffold.of(context);
    scaff.showSnackBar(SnackBar(
      content: Text("Success"),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ));
  }

  void _getCurUserInfo() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        setState(() {
          curUser = user;
        });
        print('current user ${curUser.email}');
      }
    } catch (e) {
      print(e);
    }
  }

  void _uploadImageToFireBase() async {
    final StorageReference postImageRef =
        FirebaseStorage.instance.ref().child("Images");
    var timeKey = new DateTime.now();
    final StorageUploadTask uploadTask = postImageRef
        .child(timeKey.toString() + ".jpg")
        .putFile(File(widget.imagePath));
    var downLoadImageUrl =
        await (await uploadTask.onComplete).ref.getDownloadURL();
    setState(() {
      imageUrl = downLoadImageUrl;
    });
  }
}
