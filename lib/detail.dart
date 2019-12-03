import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'itemlist.dart';


class Detail extends StatefulWidget {
  Detail({Key key, this.title, this.imageUrl, this.description, this.price, this.user}) : super(key: key);
  final String title;
  final String user;
  final int price;
  final String imageUrl;
  final String description;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Column(
          children: <Widget>[
            myAppBar(),
            imageDisplay(),
            SizedBox(height: 10),
            contents(),
          ],
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

  void _toListView() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ItemList()));
  }

  Widget imageDisplay(){
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Stack(
        children: <Widget>[
          (widget.imageUrl == "" || widget.imageUrl == null) ? Image.asset('images/image.jpg'): Image.network(widget.imageUrl),
        ],
      ),
    );
  }


  Widget myAppBar(){
    return Container(
      padding: EdgeInsets.only(top: 40),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Text('Item Detail Page',
                     textAlign: TextAlign.center,
                     style: TextStyle(
                         fontSize: 26,
                         color: Colors.green,
                         fontWeight: FontWeight.bold                ),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget contents(){
    return Container(
      padding: EdgeInsets.only(left: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          content('Title: ',widget.title),
          SizedBox(height: 10.0),
          content('Price: ',widget.price.toString()),
          SizedBox(height: 10.0),
          content('Sell By: ',widget.user),
          SizedBox(height: 10.0),
          content('Description: ', widget.description),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Widget content(String des, String content){
    return Text(
      des + content,
      textAlign: TextAlign.left,
      style: TextStyle(height: 1.5, color: Colors.black, fontSize: 16),);
  }
}


