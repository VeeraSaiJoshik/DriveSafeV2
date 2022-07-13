import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:drivesafev2/models/User.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class DriveSafeHomePage extends StatefulWidget {
  User UserProfile;
  DriveSafeHomePage(this.UserProfile);

  @override
  _DriveSafeHomePageState createState() => _DriveSafeHomePageState();
}

// Main test case : 2670440300

class _DriveSafeHomePageState extends State<DriveSafeHomePage> {
  @override
  late final AnimationController controller;
 

  Future<List<User>> getData() async {
    List<User> allUserList = [];
    final finalData = await FirebaseDatabase.instance.ref("User").get();
    Map data = finalData.value as Map;
    List friends = [];
    List friendRequests = [];
    List LocationSharingPeople = [];
    List friendRequestsPending = [];
    List location = [];
    List numberList = [];
    List chosenNumber = [];
    data.forEach((key, value) {
      if (data.containsKey("friends")) {
        friends = data["friends"];
      }
      print("1");
      if (data.containsKey("friendReqeusts")) {
        friendRequests.addAll(data["friendReqeusts"]);
      }
      print("2");
      if (data.containsKey("locationSharingPeople")) {
        LocationSharingPeople.addAll(data["locationSharingPeople"]);
      }
      print("3");
      if (data.containsKey("friendRequestsPending")) {
        friendRequestsPending.addAll(data["friendRequestsPending"]);
      }
      print("4");
      if (data.containsKey("location")) {
        location.addAll(["location"]);
      }
      print("5");
      if (data.containsKey("phoneNumbersChosen")) {
        numberList.addAll(["phoneNumbersChosen"]);
      }
      print("6");
      if (data.containsKey("phoneNumbersChosen")) {
        chosenNumber.addAll(data["phoneNumbersChosen"]);
      }
      print(value);
      try {
        allUserList.add(User(
          value["firstName"],
          value["lastName"],
          key,
          value["password"],
          value["age"],
          friends,
          friendRequests,
          friendRequestsPending,
          LocationSharingPeople,
          location,
          value["image"],
          value["numberApproved"],
          value["locationTrackingOn"],
          chosenNumber,
        ));
      } catch (e) {
        print(e);
      }
    });
    return allUserList;
  }

  late List<User> Allusers;
  void initState() {
    getData().then((users) {
      setState(() {
        Allusers = users;
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String fullName;
    double textSize = MediaQuery.of(context).textScaleFactor;
    Color mainColor = Colors.grey.shade300;

    return Scaffold(
        backgroundColor: mainColor,
        body: Center(
            child: Container(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.06,
              ),
              Neumorphic(
                style: NeumorphicStyle(
                    boxShape: NeumorphicBoxShape.circle(),
                    depth: 10,
                    shadowLightColor: Color.fromARGB(255, 193, 217, 221),
                    intensity: 1,
                    border: NeumorphicBorder(
                        color: Colors.blue, width: height * 0.01)),
                child: widget.UserProfile.image == ""
                    ? Neumorphic(
                        child: CircleAvatar(
                          radius: height * 0.15,
                          backgroundColor: Colors.grey.shade300,
                          child: NeumorphicIcon(
                            Icons.tag_faces,
                            size: textSize * 200,
                            style: NeumorphicStyle(color: Colors.blue),
                          ),
                        ),
                        style: NeumorphicStyle(
                            boxShape: NeumorphicBoxShape.circle(),
                            depth: -20,
                            shadowLightColor:
                                Color.fromARGB(255, 193, 217, 221),
                            intensity: 1,
                            border: NeumorphicBorder(
                                color: Colors.grey.shade300,
                                width: height * 0.01)))
                    : CircleAvatar(
                        radius: height * 0.16,
                        backgroundImage: NetworkImage(widget.UserProfile.image),
                      ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Text(
                widget.UserProfile.firstName +
                    " " +
                    widget.UserProfile.lastName,
                style: TextStyle(
                  fontSize: textSize * 45,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w800,
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
              SizedBox(
                height: height * 0.015,
              ),
              Container(
                  width: width * 0.9,
                  height: height * 0.535,
                  child: Column(children: [
                    Row(
                      children: [
                        Container(
                          width: width * (0.9 - 0.025) / 2,
                          height: height * 0.46 / 2,
                          child: NeumorphicButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "FriendSreen",
                                  arguments: [widget.UserProfile, Allusers]);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: width * (0.9 - 0.025) / 2,
                                  child: Lottie.network(
                                      "https://assets6.lottiefiles.com/private_files/lf30_uvrwjrrs.json"),
                                  height: height * 0.16,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: width * (0.95 - 0.05) / 2,
                                      height: height * 0.13854,
                                    ),
                                    Text(
                                      "Contacts",
                                      style: TextStyle(
                                          color: mainColor,
                                          fontSize: textSize * 30,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ) //https://assets6.lottiefiles.com/packages/lf20_ligemumo.json
                              ],
                            ),
                            style: NeumorphicStyle(
                                depth: 5,
                                color: Colors.blue,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.all(Radius.circular(30)))),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.025,
                        ),
                        Container(
                          width: width * (0.9 - 0.025) / 2,
                          height: height * 0.46 / 2,
                          child: NeumorphicButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed("mainPage");

                              //    print(Allusers);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: width * (0.95 - 0.025) / 2,
                                  child: Lottie.network(
                                      "https://assets6.lottiefiles.com/packages/lf20_ligemumo.json"),
                                  height: height * 0.16,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: width * (0.95 - 0.025) / 2,
                                      height: height * 0.13854,
                                    ),
                                    Text(
                                      "Settings",
                                      style: TextStyle(
                                          color: mainColor,
                                          fontSize: textSize * 30,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ) //
                              ],
                            ),
                            drawSurfaceAboveChild: true,
                            style: NeumorphicStyle(
                                depth: 5,
                                color: Colors.blue,
                                border: NeumorphicBorder(),
                                shadowLightColor: Colors.transparent,
                                lightSource: LightSource.topLeft,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.all(Radius.circular(30)))),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Container(
                      width: width * (0.95),
                      height: height * ((0.46 / 2) + 0.04),
                      child: NeumorphicButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed("DrivingScreen");
                        },
                        child: Stack(
                          children: [
                            Lottie.network(
                                "https://assets7.lottiefiles.com/temporary_files/GvQobl.json",
                                height: 300,
                                width: 300,
                                animate: true,
                                repeat: false),
                            Column(
                              children: [
                                Container(
                                  height: height * 0.17,
                                ),
                              ],
                            ) //https://assets6.lottiefiles.com/packages/lf20_ligemumo.json
                          ],
                        ),
                        style: NeumorphicStyle(
                            depth: 5,
                            color: Colors.blue,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.all(Radius.circular(30)))),
                      ),
                    ),
                  ]))
            ],
          ),
        )));
  }
}
