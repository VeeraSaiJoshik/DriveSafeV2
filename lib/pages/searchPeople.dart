import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:drivesafev2/python/searchAlgorithm.dart';
import 'package:drivesafev2/models/User.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class searchPeople extends StatefulWidget {
  double height;
  double width;
  var textSize;
  TextEditingController textEditingController;
  User currentUser;
  List<User> allUser;
  searchPeople(this.height, this.width, this.textEditingController,
      this.textSize, this.currentUser, this.allUser);

  @override
  _searchPeopleState createState() => _searchPeopleState();
}

class _searchPeopleState extends State<searchPeople> {
  @override
  List<String> allDisplayNames = [];
  int highest = 0;
  late List<int> answer = [];
  late List<String> tempList2 = [];
  List<String> friendsList = [];
  List<String> requestList = [];
  void initState() {
    for (int i = 0; i < widget.allUser.length; i++) {
      allDisplayNames
          .add(widget.allUser[i].firstName + " " + widget.allUser[i].lastName);
    }
    tempList2.addAll(allDisplayNames);
    for (int k = 0; k < tempList2.length; k++) {
      if (tempList2[k].length > highest) {
        highest = tempList2[k].length;
      }
    }
    for (int k = 0; k < tempList2.length; k++) {
      for (int spaceI = tempList2[k].length; spaceI < highest; spaceI++) {
        tempList2[k] = tempList2[k] + " ";
      }
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: widget.height,
        width: widget.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: widget.height * 0.07,
          ),
          Container(
            height: widget.height * 0.08,
            width: widget.width * 0.95,
            child: Row(
              children: [
                Neumorphic(
                  child: Container(
                      width: widget.width * 0.95,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            fontSize: widget.textSize * 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue),
                        textAlign: TextAlign.center,
                        onChanged: (text) {
                          print(allDisplayNames);
                          List<String> dummy = allDisplayNames;
                          setState(() {
                            answer = searchNames(tempList2, text, highest);
                          });
                          print("why");
                          print(answer);
                        },
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding:
                                  EdgeInsets.only(left: widget.width * 0.03),
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: Colors.blue,
                                iconSize: widget.textSize * 40,
                              ),
                            ),
                            suffixIcon: Padding(
                              padding:
                                  EdgeInsets.only(right: widget.width * 0.03),
                              child: IconButton(
                                icon: Icon(CupertinoIcons.search),
                                color: Colors.blue,
                                iconSize: widget.textSize * 40,
                                onPressed: () {},
                              ),
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                            contentPadding: EdgeInsets.only(
                              bottom: widget.height * 0.01,
                              top: widget.height * 0.01,
                              left: 0,
                            )),
                        controller: widget.textEditingController,
                      )),
                  style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.roundRect(
                          const BorderRadius.all(Radius.circular(100))),
                      depth: 15,
                      color: Colors.grey.shade300,
                      border: NeumorphicBorder(color: Colors.blue, width: 3),
                      lightSource: LightSource.topLeft,
                      shape: NeumorphicShape.concave),
                ),
              ],
            ),
          ),
          Container(
              height: widget.height * 0.806,
              /*color: Colors.black,*/
              //   color: Colors.pink,
              child: Scrollbar(
                thickness: 10,
                radius: Radius.circular(50),
                isAlwaysShown: true,
                child: ListView(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02),
                    children: [
                      ...answer.map((userArea) {
                        double height = widget.height;
                        User user = widget.allUser[userArea];
                        User appUser = widget.currentUser;
                        List<String> awaitList = requestList;

                        // giant code
                        Color finalColor = Colors.blue;
                        print("here");
                        bool flag = true;
                        for (int i = 0;
                            i < appUser.friendRequests.length;
                            i++) {
                          if (user.phoneNumber ==
                              appUser.friendRequests[i][1]) {
                            flag = false;
                            break;
                          }
                        }
                        if (widget.currentUser.friends
                            .contains(widget.allUser[userArea])) {
                          finalColor = Colors.greenAccent;
                        } else if (!flag) {
                          finalColor = Colors.orange;
                        }
                        Color color = finalColor;

                        return Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            height: widget.height * 0.15,
                            margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.025,
                                right:
                                    MediaQuery.of(context).size.width * 0.025,
                                bottom: widget.height * 0.02),
                            //   color: Colors.black,
                            child: InkWell(
                              onDoubleTap: () async {
                                print(appUser.phoneNumber);
                                print(["pending", user.phoneNumber]);
                                bool flag = true;
                                for (int i = 0;
                                    i < appUser.friendRequests.length;
                                    i++) {
                                  if (user.phoneNumber ==
                                      appUser.friendRequests[i][1]) {
                                    flag = false;
                                    break;
                                  }
                                }
                                print(flag);
                                if (user.phoneNumber == appUser.phoneNumber) {
                                  print("dumbass");
                                } else if (flag == false) {
                                  print("it is already here");
                                } else {
                                  setState(() {
                                    appUser.friendRequests
                                        .add(["pending", user.phoneNumber]);
                                    answer = answer;
                                  });
                                  await FirebaseDatabase.instance
                                      .ref("User")
                                      .update({
                                    appUser.phoneNumber: {
                                      "age": appUser.age,
                                      "firstName": appUser.firstName,
                                      "lastName": appUser.lastName,
                                      "friendReqeusts": appUser.friendRequests,
                                      "friendRequestsPending":
                                          appUser.friendRequestsPending,
                                      "image": appUser.image,
                                      "password": appUser.password,
                                      "friends": appUser.friends,
                                      "location": appUser.location,
                                      "phoneNumber": appUser.phoneNumber,
                                      "locationSharingPeople":
                                          appUser.LocationSharingPeople,
                                      "numberApproved": false,
                                      "locationTrackingOn": false,
                                      "phoneNumbersChosen": []
                                    }
                                  });
                                }
                              },
                              child: Neumorphic(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                    Neumorphic(
                                      style: NeumorphicStyle(
                                          boxShape: NeumorphicBoxShape.circle(),
                                          depth: -15,
                                          color: Colors.grey.shade300,
                                          lightSource: LightSource.topLeft,
                                          border: NeumorphicBorder(
                                              color: color, width: 5),
                                          shape: NeumorphicShape.concave),
                                      child: Container(
                                          height: widget.height * 0.11,
                                          width: widget.height * 0.11,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100)),
                                          )),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          user.phoneNumber,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: color,
                                              fontSize: MediaQuery.of(context)
                                                      .textScaleFactor *
                                                  25),
                                        ),
                                        SizedBox(
                                          height: widget.height * 0.01,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.firstName +
                                                  " " +
                                                  user.lastName,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: color,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .textScaleFactor *
                                                          20),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                style: NeumorphicStyle(
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        const BorderRadius.all(
                                            Radius.circular(45))),
                                    depth: 15,
                                    color: Colors.grey.shade300,
                                    lightSource: LightSource.topLeft,
                                    shape: NeumorphicShape.concave),
                              ),
                            ));
                      }).toList()
                    ]),
              ))
        ]),
      ),
    );
  }
}

class searchChildWidget extends StatefulWidget {
  double height;
  User user;
  Color color;
  User appUser;
  List<String> awaitList;
  var answer;
  searchChildWidget(this.height, this.user, this.color, this.appUser,
      this.awaitList, this.answer);
  @override
  _searchChildWidgetState createState() => _searchChildWidgetState();
}

class _searchChildWidgetState extends State<searchChildWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: widget.height * 0.15,
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.025,
            right: MediaQuery.of(context).size.width * 0.025,
            bottom: widget.height * 0.02),
        //   color: Colors.black,
        child: InkWell(
          onDoubleTap: () async {
            print(widget.appUser.phoneNumber);
            print(["pending", widget.user.phoneNumber]);
            bool flag = true;
            for (int i = 0; i < widget.appUser.friendRequests.length; i++) {
              if (widget.user.phoneNumber ==
                  widget.appUser.friendRequests[i][1]) {
                flag = false;
                break;
              }
            }
            print(flag);
            if (widget.user.phoneNumber == widget.appUser.phoneNumber) {
              print("dumbass");
            } else if (flag == false) {
              print("it is already here");
            } else {
              setState(() {
                widget.appUser.friendRequests
                    .add(["pending", widget.user.phoneNumber]);
                widget.answer = widget.answer;
              });
              await FirebaseDatabase.instance.ref("User").update({
                widget.appUser.phoneNumber: {
                  "age": widget.appUser.age,
                  "firstName": widget.appUser.firstName,
                  "lastName": widget.appUser.lastName,
                  "friendReqeusts": widget.appUser.friendRequests,
                  "friendRequestsPending": widget.appUser.friendRequestsPending,
                  "image": widget.appUser.image,
                  "password": widget.appUser.password,
                  "friends": widget.appUser.friends,
                  "location": widget.appUser.location,
                  "phoneNumber": widget.appUser.phoneNumber,
                  "locationSharingPeople": widget.appUser.LocationSharingPeople,
                  "numberApproved": false,
                  "locationTrackingOn": false,
                  "phoneNumbersChosen": []
                }
              });
            }
          },
          child: Neumorphic(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Neumorphic(
                  style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.circle(),
                      depth: -15,
                      color: Colors.grey.shade300,
                      lightSource: LightSource.topLeft,
                      border: NeumorphicBorder(color: widget.color, width: 5),
                      shape: NeumorphicShape.concave),
                  child: Container(
                      height: widget.height * 0.11,
                      width: widget.height * 0.11,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      )),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.user.phoneNumber,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: widget.color,
                          fontSize:
                              MediaQuery.of(context).textScaleFactor * 25),
                    ),
                    SizedBox(
                      height: widget.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.firstName + " " + widget.user.lastName,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: widget.color,
                              fontSize:
                                  MediaQuery.of(context).textScaleFactor * 20),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.08,
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
            style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.roundRect(
                    const BorderRadius.all(Radius.circular(45))),
                depth: 15,
                color: Colors.grey.shade300,
                lightSource: LightSource.topLeft,
                shape: NeumorphicShape.concave),
          ),
        ));
  }
}
