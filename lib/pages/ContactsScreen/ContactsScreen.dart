import 'package:flutter/material.dart';
class ContactsSreen extends StatefulWidget {
  const ContactsSreen({ Key? key }) : super(key: key);

  @override
  _ContactsSreenState createState() => _ContactsSreenState();
}

class _ContactsSreenState extends State<ContactsSreen> {
  @override
  Widget build(BuildContext context) {
    double width =MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width : width, 
        height : height,
        child : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width : width,
              height : height * 0.3 ,
              color : Colors.blue,
            )
          ],
        )
      ),
    );
  }
}