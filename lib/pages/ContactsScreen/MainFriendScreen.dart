import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:drivesafev2/models/User.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../python/searchAlgorithm.dart';

class MainFriendScreen extends StatefulWidget {
  double height;
  double width;
  double textSize;
  User currentUser;
  TextEditingController textEditingController;
  MainFriendScreen(this.height, this.width, this.textEditingController,
      this.textSize, this.currentUser,
      {Key? key})
      : super(key: key);
  @override
  MainFriendScreenState createState() => MainFriendScreenState();
}

class MainFriendScreenState extends State<MainFriendScreen> {
  @override
  //begin
  //Variable decleration begins
  List<String> allDisplayNames = [];
  int index = 0;
  int highest = 0;
  late List answer = [];
  List<Color> colorList1 = [Colors.blue, Colors.blue.shade900];
  List<Color> colorList2 = [Colors.blue.shade900, Colors.blue];
  List<List> friendsList = [];
  List<int> requestList = [];
  List<String> requestListAnalysisList = [];
  List<String> phoneNumberList = [];

  int longestRequestListValue = 0;
  late User currentUser =
      User(" ", " ", " ", " ", 0, [], [], [], [], [], "", false, false, []);
  late List<User> allusers = [];
  bool flag = false;
  List friends = [];
  List friendRequests = [];
  List LocationSharingPeople = [];
  List friendRequestsPending = [];
  List location = [];
  List numberList = [];
  List chosenNumber = [];
  List<bool> _selected = List.generate(2, (_) => false);
  //Variable declertion ends
  Future<User> getUserData(String phoneNumber) async {
    final Data =
        await FirebaseDatabase.instance.ref("User/" + phoneNumber).get();
    phoneNumber = phoneNumber.trim();
    phoneNumber = phoneNumber.replaceAll(" ", "");
    Map data = Data.value as Map;
    List friends = [];
    List friendRequests = [];
    List friendRequestsPending = [];
    List location = [];
    List numberList = [];
    List chosenNumber = [];
    if (phoneNumber[0] != "+") {
      phoneNumber = "+1" + phoneNumber;
    }
    if (data.containsKey("friends")) {
      friends.addAll(data["friends"]);
    }
    if (data.containsKey("friendReqeusts")) {
      friendRequests.addAll(data["friendReqeusts"]);
    }
    if (data.containsKey("locationSharingPeople")) {
      LocationSharingPeople.addAll(data["locationSharingPeople"]);
    }
    if (data.containsKey("friendRequestsPending")) {
      friendRequestsPending.addAll(data["friendRequestsPending"]);
    }
    if (data.containsKey("location")) {
      location.addAll(["location"]);
    }
    if (data.containsKey("phoneNumbersChosen")) {
      numberList.addAll(["phoneNumbersChosen"]);
    }
    if (data.containsKey("phoneNumbersChosen")) {
      chosenNumber.addAll(data["phoneNumbersChosen"]);
    }
    return User(
      data["firstName"],
      data["lastName"],
      data["phoneNumber"],
      data["password"],
      data["age"],
      friends,
      friendRequests,
      friendRequestsPending,
      LocationSharingPeople,
      location,
      data["image"],
      data["numberApproved"],
      data["locationTrackingOn"],
      chosenNumber,
    );
  }

  Future<List<User>> getData() async {
    List<User> allUserList = [];
    final finalData = await FirebaseDatabase.instance.ref("User").get();
    Map data = finalData.value as Map;

    data.forEach((key, value) {
      if (data.containsKey("friends")) {
        friends.addAll(data["friends"]);
      }
      if (data.containsKey("friendReqeusts")) {
        friendRequests.addAll(data["friendReqeusts"]);
      }
      if (data.containsKey("locationSharingPeople")) {
        LocationSharingPeople.addAll(data["locationSharingPeople"]);
      }
      if (data.containsKey("friendRequestsPending")) {
        friendRequestsPending.addAll(data["friendRequestsPending"]);
      }
      if (data.containsKey("location")) {
        location.addAll(["location"]);
      }
      if (data.containsKey("phoneNumbersChosen")) {
        numberList.addAll(["phoneNumbersChosen"]);
      }
      if (data.containsKey("phoneNumbersChosen")) {
        chosenNumber.addAll(data["phoneNumbersChosen"]);
      }
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
      } catch (e) {}
    });
    return allUserList;
  }

  void goToUserMapPage() async {
    print("this is the function");
  }

  void collectData() async {
    await getUserData(widget.currentUser.phoneNumber).then((value) {
      setState(() {
        currentUser = value;
      });
    });
    await getData().then((users) {
      setState(() {
        allusers.addAll(users);
      });
      setState(() {
        friendsList;
      });
      print(users[0].firstName);
      for (int i = 0; i < currentUser.friends.length; i++) {
        for (int j = 0; j < allusers.length; j++) {
          if (allusers[j].phoneNumber == currentUser.friends[i]) {
            requestList.add(j);
            print(users[j].firstName + users[j].lastName);
            requestListAnalysisList
                .add(users[j].firstName + " " + users[j].lastName);
            phoneNumberList.add(users[j].phoneNumber);
            break;
          }
        }
      }
      print(friendsList);
      for (int i = 0; i < requestListAnalysisList.length; i++) {
        if (longestRequestListValue < requestListAnalysisList[i].length) {
          longestRequestListValue = requestListAnalysisList[i].length;
        }
      }
      for (int i = 0; i < requestListAnalysisList.length; i++) {
        for (int j = requestListAnalysisList[i].length;
            j < longestRequestListValue;
            j++) {
          requestListAnalysisList[i] = requestListAnalysisList[i] + " ";
        }
      }
      print(requestListAnalysisList);
      setState(() {
        requestList;
        answer.addAll(requestList);
      });
    });
  }

  void initFunction() async {
    collectData();
  }

  void initState() {
    initFunction();
    setState(() {
      friendsList;
    });
    setState(() {
      requestList;
    });
    print(friendsList);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        width: widget.width,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
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
                                  flag = true;
                                  List<String> dummy = allDisplayNames;
                                  setState(() {
                                    List tempAns = [];

                                    answer = searchNames(
                                        requestListAnalysisList,
                                        text,
                                        longestRequestListValue + 1,
                                        true);
                                    if (allusers.length == answer.length ||
                                        answer.isEmpty) {
                                      if (text != "") {
                                        answer = [];
                                        print(searchPhoneNumbers(
                                            phoneNumberList, text, flag));
                                        answer.addAll(searchPhoneNumbers(
                                            phoneNumberList, text, flag));
                                        print(answer);
                                      }
                                    }
                                    tempAns.addAll(answer);
                                    answer = [];
                                    for (int i = 0; i < tempAns.length; i++) {
                                      answer.add(requestList[tempAns[i]]);
                                    }
                                    setState(() {
                                      answer;
                                    });
                                    print(longestRequestListValue);
                                    print(text);
                                    print(requestListAnalysisList);
                                    print(answer);
                                  });
                                },
                                decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(
                                          left: widget.width * 0.03),
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
                                      padding: EdgeInsets.only(
                                          right: widget.width * 0.03),
                                      child: IconButton(
                                        icon: Icon(CupertinoIcons.search),
                                        color: Colors.blue,
                                        iconSize: widget.textSize * 40,
                                        onPressed: () {},
                                      ),
                                    ),
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100))),
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
                              border: NeumorphicBorder(
                                  color: Colors.blue, width: 3),
                              lightSource: LightSource.topLeft,
                              shape: NeumorphicShape.concave),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: widget.width,
                    height: widget.height * 0.8,
                    child: Column(
                      children: [
                        Container(
                            height: widget.height * 0.8,
                            width: widget.width,
                            child: ListView(
                              children: [
                                ...answer.map((e) {
                                  Color color = Colors.green;
                                  return Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      height: widget.height * 0.15,
                                      margin: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.025,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.025,
                                          bottom: widget.height * 0.02),
                                      //   color: Colors.black,
                                      child: InkWell(
                                        child: Neumorphic(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  child: Row(children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                ),
                                                Neumorphic(
                                                  style: NeumorphicStyle(
                                                      boxShape:
                                                          NeumorphicBoxShape
                                                              .circle(),
                                                      depth: -15,
                                                      color:
                                                          Colors.grey.shade300,
                                                      lightSource:
                                                          LightSource.topLeft,
                                                      border: NeumorphicBorder(
                                                          color: color,
                                                          width: 5),
                                                      shape: NeumorphicShape
                                                          .concave),
                                                  child: currentUser.image == ""
                                                      ? CircleAvatar(
                                                          radius:
                                                              widget.height *
                                                                  (0.11 / 2),
                                                          backgroundColor:
                                                              Colors.grey
                                                                  .shade300,
                                                          child: NeumorphicIcon(
                                                            Icons.tag_faces,
                                                            size: widget
                                                                    .textSize *
                                                                70,
                                                            style:
                                                                NeumorphicStyle(
                                                                    color:
                                                                        color),
                                                          ),
                                                        )
                                                      : CircleAvatar(
                                                          radius:
                                                              widget.height *
                                                                  (0.11 / 2),
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  currentUser
                                                                      .image),
                                                        ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      allusers[e].phoneNumber,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: color,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .textScaleFactor *
                                                              25),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          widget.height * 0.01,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          allusers[e]
                                                                  .firstName +
                                                              " " +
                                                              allusers[e]
                                                                  .lastName,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: color,
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .textScaleFactor *
                                                                  20),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ])),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    AnimatedSwitcher(
                                                      duration:
                                                          Duration(seconds: 10),
                                                      transitionBuilder: (Widget
                                                                  child,
                                                              Animation<double>
                                                                  animation) =>
                                                          FadeTransition(
                                                              opacity:
                                                                  animation,
                                                              child: child),
                                                      child: currentUser
                                                                  .LocationSharingPeople
                                                              .contains(allusers[
                                                                      e]
                                                                  .phoneNumber)
                                                          ? InkWell(
                                                              onTap: () async {
                                                                setState(() => currentUser
                                                                        .LocationSharingPeople
                                                                    .remove(allusers[
                                                                            e]
                                                                        .phoneNumber));
                                                                print(currentUser
                                                                    .LocationSharingPeople);
                                                                await FirebaseDatabase
                                                                    .instance
                                                                    .ref("User")
                                                                    .child(currentUser
                                                                        .phoneNumber)
                                                                    .child(
                                                                        "locationSharingPeople")
                                                                    .set(currentUser
                                                                        .LocationSharingPeople);
                                                              },
                                                              child:
                                                                  NeumorphicIcon(
                                                                Icons
                                                                    .location_on,
                                                                size: widget
                                                                        .textSize *
                                                                    60,
                                                                style:
                                                                    NeumorphicStyle(
                                                                  color: Colors
                                                                      .lightGreen
                                                                      .shade700,
                                                                ),
                                                              ),
                                                            )
                                                          : InkWell(
                                                              child:
                                                                  NeumorphicIcon(
                                                                Icons
                                                                    .location_off,
                                                                size: widget
                                                                        .textSize *
                                                                    60,
                                                                style: NeumorphicStyle(
                                                                    color: Colors
                                                                        .red
                                                                        .shade600),
                                                              ),
                                                              onTap: () async {
                                                                setState(() => currentUser
                                                                        .LocationSharingPeople
                                                                    .add(allusers[
                                                                            e]
                                                                        .phoneNumber));
                                                                await FirebaseDatabase
                                                                    .instance
                                                                    .ref("User")
                                                                    .child(currentUser
                                                                        .phoneNumber)
                                                                    .child(
                                                                        "locationSharingPeople")
                                                                    .set(currentUser
                                                                        .LocationSharingPeople);
                                                              },
                                                            ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.015,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          style: NeumorphicStyle(
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
                                                      const BorderRadius.all(
                                                          Radius.circular(45))),
                                              depth: 15,
                                              color: Colors.grey.shade300,
                                              lightSource: LightSource.topLeft,
                                              shape: NeumorphicShape.concave),
                                        ),
                                      ));
                                }).toList()
                                //=> Text(allusers[e[1]].phoneNumber)
                              ],
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: widget.height,
              width: widget.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: widget.height * 0.88,
                  ),
                  Container(
                    height: widget.width * 0.17,
                    width: widget.width * 0.17,
                    margin: EdgeInsets.only(right: widget.width * 0.025),
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                        },
                        child: Icon(
                          Icons.map,
                          color: Colors.grey.shade300,
                          size: widget.textSize * 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
//down