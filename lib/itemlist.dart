import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'post.dart';
import 'package:garage_sale_neu_sv/main.dart';
import 'package:garage_sale_neu_sv/detail.dart';

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    final title = 'Items For Sale';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: _appBar(),
        body: BuildItemList(),
        floatingActionButton: _floatBtn(),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text('Items List'),
      backgroundColor: Colors.green,
      actions: <Widget>[
        FlatButton(
          textColor: Colors.white,
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Welcome()));
          },
          child: Text("Sign Out"),
          shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
        ),
      ],
    );
  }

  Widget _floatBtn() {
    return FloatingActionButton.extended(
      icon: Icon(Icons.add),
      label: Text('NEW POST'),
      backgroundColor: Colors.pink,
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Post()));
      },
    );
  }
}

class BuildItemList extends StatefulWidget {
  @override
  _BuildItemListState createState() => _BuildItemListState();
}

class _BuildItemListState extends State<BuildItemList> {
  final fireStore = Firestore.instance;

  final List<Widget> lists = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStore.collection('Posts').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.orange,
            ),
          );
        }

        final documents = snapshot.data.documents;
        for (var doc in documents) {
          final user = doc.data['user'];
          final price = doc.data['price'];
          final title = doc.data['title'];
          final description = doc.data['description'];
          final imageUrl = doc.data['image_path'];

          lists.add(ListTile(
            trailing: (imageUrl == "" || imageUrl == null)
                ? Image.asset('images/image.jpg')
                : Image.network(imageUrl),
            title: Text(title,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            subtitle: Text('Price: \$' + price.toString(),
                style: TextStyle(fontSize: 14.0)),
            onTap: () => _onTapped(title, imageUrl, description, price, user),
          ));
        }
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.green,
          ),
          itemCount: lists.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Center(child: lists[index],),
          ),

        );
      },
    );
  }

  void _onTapped(String title, String imageUrl, String description, int price,
      String user) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Detail(
              title: title,
              imageUrl: imageUrl,
              description: description,
              price: price,
              user: user),
        ));
  }
}
