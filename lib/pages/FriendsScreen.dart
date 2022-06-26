import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({Key? key}) : super(key: key);

  @override
  _FriendScreenState createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String fullName;
    double textSize = MediaQuery.of(context).textScaleFactor;
    Color mainColor = Colors.grey.shade300;
    int index = 0;
    return Scaffold(
      backgroundColor: mainColor,
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(
            Icons.person,
            size: textSize * 40,
            color: mainColor,
          ),
          Icon(
            Icons.phone,
            size: textSize * 40,
            color: mainColor,
          ),
          Icon(
            Icons.person_add,
            size: textSize * 40,
            color: mainColor,
          ),
        ],
        onTap: (number) => setState(() {
          index = number;
        }),
        index: index,
        color: Colors.blue,
        backgroundColor: mainColor,
      ),
    );
  }
}
