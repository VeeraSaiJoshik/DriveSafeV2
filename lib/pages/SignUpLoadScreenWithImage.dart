import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:drivesafev2/models/User.dart';
import 'DriveSafeHomePage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SignUpLoadScreenWithImage extends StatefulWidget {
  User appUser;
  SignUpLoadScreenWithImage(this.appUser);
  @override
  SignUpLoadScreenWithImageState createState() =>
      SignUpLoadScreenWithImageState();
}

class SignUpLoadScreenWithImageState extends State<SignUpLoadScreenWithImage> {
  void upload() async {
    await FirebaseDatabase.instance.ref("User").update({
      widget.appUser.phoneNumber: {
        "age": widget.appUser.age,
        "firstName": widget.appUser.firstName,
        "lastName": widget.appUser.lastName,
        "friendReqeusts": widget.appUser.friendRequests,
        "image": "",
        "password": widget.appUser.password,
        "friends": widget.appUser.friends,
        "location": widget.appUser.location,
        "phoneNumber": widget.appUser.phoneNumber,
      }
    });
  }

  void initState() {
    upload();
    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String fullName;
    double textSize = MediaQuery.of(context).textScaleFactor;
    Color mainColor = Colors.grey.shade300;
    int animatedSize = 0;
    return Scaffold(
      backgroundColor: mainColor,
      body: Stack(children: [
        Container(
          height: height,
          width: width,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                InkWell(
                  onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              DriveSafeHomePage(widget.appUser))),
                      (route) => false),
                  child: NeumorphicIcon(
                    CupertinoIcons.car_detailed,
                    style: NeumorphicStyle(
                      color: Colors.blue,
                    ),
                    size: textSize * (180 + animatedSize),
                  ),
                ),
                Text(
                  "Thank You",
                  style: TextStyle(
                    fontSize: textSize * 50,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                    shadows: [
                      const Shadow(
                          offset: Offset(1.5, 1.5),
                          color: Colors.black38,
                          blurRadius: 10),
                      Shadow(
                          offset: Offset(-1.5, -1.5),
                          color: Colors.white.withOpacity(0.85),
                          blurRadius: 10)
                    ],
                    color: Colors.blue,
                  ),
                ),
                Container(
                  width: width,
                  padding: EdgeInsets.symmetric(
                      vertical: 0, horizontal: width * 0.15),
                  child: Text(
                    "Thankyou for downloading the app and playing your part in making the roads a tad safer",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: textSize * 20,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w700,
                      shadows: [
                        const Shadow(
                            offset: Offset(1.5, 1.5),
                            color: Colors.black38,
                            blurRadius: 10),
                        Shadow(
                            offset: Offset(-1.5, -1.5),
                            color: Colors.white.withOpacity(0.85),
                            blurRadius: 10)
                      ],
                      color: Colors.blue,
                    ),
                  ),
                ),
              ])),
        ),
        Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: height * 0.03),
            width: width,
            padding:
                EdgeInsets.symmetric(vertical: 0, horizontal: width * 0.15),
            child: Text(
              "click the car to begin",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: textSize * 15,
                fontFamily: "Nunito",
                fontWeight: FontWeight.w700,
                shadows: [
                  const Shadow(
                      offset: Offset(1.5, 1.5),
                      color: Colors.black38,
                      blurRadius: 10),
                  Shadow(
                      offset: Offset(-1.5, -1.5),
                      color: Colors.white.withOpacity(0.85),
                      blurRadius: 10)
                ],
                color: Colors.blue,
              ),
            ))
      ]),
    );
  }
}