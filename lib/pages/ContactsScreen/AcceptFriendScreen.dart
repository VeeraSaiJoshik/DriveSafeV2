import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:drivesafev2/models/User.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:toggle_bar/toggle_bar.dart';

import '../../python/searchAlgorithm.dart';

class FriendsScreen extends StatefulWidget {
  double height;
  double width;
  double textSize;
  User currentUser;
  TextEditingController textEditingController;
  FriendsScreen(this.height, this.width, this.textEditingController,
      this.textSize, this.currentUser,
      {Key? key})
      : super(key: key);
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  //begin
  //Variable decleration begins
  List<String> allDisplayNames = [];
  int counter = 0;
  int index = 0;
  int highest = 0;
  late List answer = [];
  late List<String> tempList2 = [];
  List<Color> colorList1 = [Colors.blue, Colors.blue.shade900];
  List<Color> colorList2 = [Colors.blue.shade900, Colors.blue];
  List<List> friendsList = [];
  List<int> requestList = [];
  List<String> friendListAnalysisList = [];
  List<String> requestListAnalysisList = [];
  int longestFriendListvalue = 0;
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
    List LocationSharingPeople = [];
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

  void collectData() async {
    for (int i = 0; i < allusers.length; i++) {
      answer.add(i);
    }
    await getUserData(widget.currentUser.phoneNumber).then((value) {
      setState(() {
        currentUser = value;
      });
    });
    await getData().then((users) {
      setState(() {
        allusers.addAll(users);
      });
      for (int i = 0; i < currentUser.friendRequests.length; i++) {
        for (int j = 0; j < allusers.length; j++) {
          if (allusers[j].phoneNumber == currentUser.friendRequests[i][1]) {
            friendsList.add([currentUser.friendRequests[i][0], j]);
            friendListAnalysisList
                .add(users[j].firstName + " " + users[j].lastName);
            break;
          }
        }
      }
      for (int i = 0; i < friendListAnalysisList.length; i++) {
        if (friendListAnalysisList[i].length > longestFriendListvalue) {
          longestFriendListvalue = friendListAnalysisList[i].length;
          print(friendListAnalysisList[i]);
          print("this is longrestFriendValye");
          print(longestFriendListvalue);
        }
      }
      for (int i = 0; i < friendListAnalysisList.length; i++) {
        for (int j = friendListAnalysisList[i].length;
            j < longestFriendListvalue;
            j++) {
          friendListAnalysisList[i] = friendListAnalysisList[i] + " ";
        }
      }
      setState(() {
        friendsList;
      });
      print(users[0].firstName);
      for (int i = 0; i < currentUser.friendRequestsPending.length; i++) {
        for (int j = 0; j < allusers.length; j++) {
          if (allusers[j].phoneNumber == currentUser.friendRequestsPending[i]) {
            requestList.add(j);
            print(users[j].firstName + users[j].lastName);
            requestListAnalysisList
                .add(users[j].firstName + " " + users[j].lastName);
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
      print(friendListAnalysisList);
      print(requestListAnalysisList);
      setState(() {
        requestList;
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
            Column(
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
                                List<String> dummy = allDisplayNames;
                                setState(() {
                                  List tempAns = [];
                                  if (counter == 1) {
                                    answer = searchNames(friendListAnalysisList,
                                        text, longestFriendListvalue + 1, true);
                                    tempAns.addAll(answer);
                                    answer = [];
                                    for (int i = 0; i < tempAns.length; i++) {
                                      answer.add(friendsList[tempAns[i]]);
                                    }
                                  } else {
                                    answer = searchNames(
                                        requestListAnalysisList,
                                        text,
                                        longestRequestListValue + 1,
                                        true);
                                    tempAns.addAll(answer);
                                    answer = [];
                                    for (int i = 0; i < tempAns.length; i++) {
                                      answer.add(requestList[tempAns[i]]);
                                    }
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
                            border:
                                NeumorphicBorder(color: Colors.blue, width: 3),
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
                          child: counter == 0
                              ? ListView(
                                  children: [
                                    ...answer.map((e) {
                                      Color color;
                                      color = Colors.orange;
                                      return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: widget.height * 0.23,
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
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
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
                                                            color: Colors
                                                                .grey.shade300,
                                                            lightSource:
                                                                LightSource
                                                                    .topLeft,
                                                            border:
                                                                NeumorphicBorder(
                                                                    color:
                                                                        color,
                                                                    width: 5),
                                                            shape:
                                                                NeumorphicShape
                                                                    .concave),
                                                        child: Container(
                                                            height:
                                                                widget.height *
                                                                    0.11,
                                                            width:
                                                                widget.height *
                                                                    0.11,
                                                            decoration:
                                                                const BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          100)),
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            allusers[e]
                                                                .phoneNumber,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: color,
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .textScaleFactor *
                                                                    25),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                widget.height *
                                                                    0.01,
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
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color:
                                                                        color,
                                                                    fontSize:
                                                                        MediaQuery.of(context).textScaleFactor *
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
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      NeumorphicButton(
                                                        onPressed: () async {
                                                          setState(() {
                                                            requestList
                                                                .remove(e);
                                                          });
                                                          currentUser
                                                              .friendRequestsPending
                                                              .remove(
                                                            allusers[e]
                                                                .phoneNumber,
                                                          );
                                                          friends.add(
                                                              allusers[e]
                                                                  .phoneNumber);
                                                          await FirebaseDatabase
                                                              .instance
                                                              .ref("User")
                                                              .child(currentUser
                                                                  .phoneNumber)
                                                              .set({
                                                            "age":
                                                                currentUser.age,
                                                            "firstName":
                                                                currentUser
                                                                    .firstName,
                                                            "lastName":
                                                                currentUser
                                                                    .lastName,
                                                            "friendReqeusts":
                                                                currentUser
                                                                    .friendRequests,
                                                            "friendRequestsPending":
                                                                currentUser
                                                                    .friendRequestsPending,
                                                            "image": currentUser
                                                                .image,
                                                            "password":
                                                                currentUser
                                                                    .password,
                                                            "friends": friends,
                                                            "location":
                                                                currentUser
                                                                    .location,
                                                            "phoneNumber":
                                                                currentUser
                                                                    .phoneNumber,
                                                            "locationSharingPeople":
                                                                currentUser
                                                                    .LocationSharingPeople,
                                                            "numberApproved":
                                                                false,
                                                            "locationTrackingOn":
                                                                false,
                                                            "phoneNumbersChosen":
                                                                []
                                                          }).whenComplete(
                                                                  () async {
                                                            final finalData =
                                                                await FirebaseDatabase
                                                                    .instance
                                                                    .ref("User")
                                                                    .child(allusers[
                                                                            e]
                                                                        .phoneNumber)
                                                                    .get();
                                                            Map data = finalData
                                                                .value as Map;
                                                            print(data);
                                                            List temp = [];
                                                            List finalAnswer =
                                                                [];
                                                            print(
                                                                "before jere");
                                                            temp.addAll(data[
                                                                "friendReqeusts"]);
                                                            for (int i = 0;
                                                                i < temp.length;
                                                                i++) {
                                                              if (temp[i][1] !=
                                                                  currentUser
                                                                      .phoneNumber) {
                                                                if (temp[i]
                                                                        [0] ==
                                                                    "pending") {
                                                                  finalAnswer
                                                                      .add(temp[
                                                                          i]);
                                                                }
                                                              }
                                                            }
                                                            print(finalAnswer);
                                                            await FirebaseDatabase
                                                                .instance
                                                                .ref("User")
                                                                .child(allusers[
                                                                        e]
                                                                    .phoneNumber)
                                                                .child(
                                                                    "friendReqeusts")
                                                                .set(
                                                                    finalAnswer);

                                                            if (data.containsKey(
                                                                "friends")) {
                                                              List temp2 = [];
                                                              temp2.addAll(data[
                                                                  "friends"]);
                                                              temp2.add(currentUser
                                                                  .phoneNumber);
                                                              await FirebaseDatabase
                                                                  .instance
                                                                  .ref("User")
                                                                  .child(allusers[
                                                                          e]
                                                                      .phoneNumber)
                                                                  .update({
                                                                "friends": temp2
                                                              });
                                                            } else {
                                                              await FirebaseDatabase
                                                                  .instance
                                                                  .ref("User")
                                                                  .child(allusers[
                                                                          e]
                                                                      .phoneNumber)
                                                                  .child(
                                                                      "friends")
                                                                  .set([
                                                                currentUser
                                                                    .phoneNumber
                                                              ]);
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          width: widget.width *
                                                              0.28,
                                                          height:
                                                              widget.height *
                                                                  0.025,
                                                          child: Center(
                                                            child: Text(
                                                              "Accept",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: widget
                                                                        .textSize *
                                                                    16,
                                                                fontFamily:
                                                                    "Nunito",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        style: const NeumorphicStyle(
                                                            depth: 0,
                                                            color: Colors
                                                                .lightGreen,
                                                            boxShape:
                                                                NeumorphicBoxShape
                                                                    .stadium(),
                                                            shape:
                                                                NeumorphicShape
                                                                    .concave),
                                                      ),
                                                      NeumorphicButton(
                                                        onPressed: () async {
                                                          setState((() =>
                                                              requestList
                                                                  .remove(e)));
                                                          currentUser
                                                              .friendRequestsPending
                                                              .remove(
                                                            allusers[e]
                                                                .phoneNumber,
                                                          );
                                                          await FirebaseDatabase
                                                              .instance
                                                              .ref("User")
                                                              .child(currentUser
                                                                  .phoneNumber)
                                                              .set({
                                                            "age":
                                                                currentUser.age,
                                                            "firstName":
                                                                currentUser
                                                                    .firstName,
                                                            "lastName":
                                                                currentUser
                                                                    .lastName,
                                                            "friendReqeusts":
                                                                currentUser
                                                                    .friendRequests,
                                                            "friendRequestsPending":
                                                                currentUser
                                                                    .friendRequestsPending,
                                                            "image": currentUser
                                                                .image,
                                                            "password":
                                                                currentUser
                                                                    .password,
                                                            "friends": friends,
                                                            "location":
                                                                currentUser
                                                                    .location,
                                                            "phoneNumber":
                                                                currentUser
                                                                    .phoneNumber,
                                                            "locationSharingPeople":
                                                                currentUser
                                                                    .LocationSharingPeople,
                                                            "numberApproved":
                                                                false,
                                                            "locationTrackingOn":
                                                                false,
                                                            "phoneNumbersChosen":
                                                                []
                                                          });
                                                          final finalData =
                                                              await FirebaseDatabase
                                                                  .instance
                                                                  .ref("User")
                                                                  .child(allusers[
                                                                          e]
                                                                      .phoneNumber)
                                                                  .get();
                                                          Map data = finalData
                                                              .value as Map;
                                                          print(data);
                                                          List temp = [];
                                                          List finalAnswer = [];
                                                          print("before jere");
                                                          temp.addAll(data[
                                                              "friendReqeusts"]);
                                                          for (int i = 0;
                                                              i < temp.length;
                                                              i++) {
                                                            if (temp[i][1] !=
                                                                currentUser
                                                                    .phoneNumber) {
                                                              if (temp[i][0] ==
                                                                  "pending") {
                                                                finalAnswer.add(
                                                                    temp[i]);
                                                              }
                                                            } else {
                                                              finalAnswer.add([
                                                                "rejected",
                                                                currentUser
                                                                    .phoneNumber
                                                              ]);
                                                            }
                                                          }
                                                          await FirebaseDatabase
                                                              .instance
                                                              .ref("User")
                                                              .child(allusers[e]
                                                                  .phoneNumber)
                                                              .child(
                                                                  "friendReqeusts")
                                                              .set(finalAnswer);
                                                        },
                                                        child: Container(
                                                          width: widget.width *
                                                              0.28,
                                                          height:
                                                              widget.height *
                                                                  0.025,
                                                          child: Center(
                                                            child: Text(
                                                              "Decline",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: widget
                                                                        .textSize *
                                                                    16,
                                                                fontFamily:
                                                                    "Nunito",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        style: const NeumorphicStyle(
                                                            depth: 0,
                                                            color: Colors
                                                                .redAccent,
                                                            boxShape:
                                                                NeumorphicBoxShape
                                                                    .stadium(),
                                                            shape:
                                                                NeumorphicShape
                                                                    .concave),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              style: NeumorphicStyle(
                                                  boxShape: NeumorphicBoxShape
                                                      .roundRect(
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  45))),
                                                  depth: 15,
                                                  color: Colors.grey.shade300,
                                                  lightSource:
                                                      LightSource.topLeft,
                                                  shape:
                                                      NeumorphicShape.concave),
                                            ),
                                          ));
                                    }).toList(),
                                    //=> Text(allusers[e[1]].phoneNumber)
                                  ],
                                )
                              : ListView(
                                  children: [
                                    ...answer.map((e) {
                                      Color color = Colors.red;
                                      if (e[0] == "pending") {
                                        color = Colors.orange;
                                      }
                                      return Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
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
                                                        color: Colors
                                                            .grey.shade300,
                                                        lightSource:
                                                            LightSource.topLeft,
                                                        border:
                                                            NeumorphicBorder(
                                                                color: color,
                                                                width: 5),
                                                        shape: NeumorphicShape
                                                            .concave),
                                                    child: Container(
                                                        height: widget.height *
                                                            0.11,
                                                        width: widget.height *
                                                            0.11,
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          100)),
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        allusers[e[1]]
                                                            .phoneNumber,
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
                                                        height: widget.height *
                                                            0.01,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            allusers[e[1]]
                                                                    .firstName +
                                                                " " +
                                                                allusers[e[1]]
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
                                                  )
                                                ],
                                              ),
                                              style: NeumorphicStyle(
                                                  boxShape: NeumorphicBoxShape
                                                      .roundRect(
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  45))),
                                                  depth: 15,
                                                  color: Colors.grey.shade300,
                                                  lightSource:
                                                      LightSource.topLeft,
                                                  shape:
                                                      NeumorphicShape.concave),
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
            Container(
              height: widget.height,
              width: widget.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: widget.height * 0.82),
                  Container(
                    height: widget.height * 0.1,
                    child: ToggleBar(
                      labels: const [
                        "Pending",
                        "Sent",
                      ],
                      backgroundBorder: Border.all(
                        color: Colors.blue,
                        width: 1,
                      ),
                      onSelectionUpdated: (index) {
                        answer = [];

                        setState(() {
                          if (index == 0) {
                            answer.addAll(requestList);
                          } else {
                            answer.addAll(friendsList);
                          }
                          counter = index;
                          print(counter);
                        });
                      },
                      selectedTextColor: Colors.grey.shade300,
                      textColor: Colors.blue,
                      backgroundColor: Colors.grey.shade300,
                      selectedTabColor: Colors.blue,
                      borderRadius: 100,
                      labelTextStyle: TextStyle(
                          fontSize: widget.textSize * 20,
                          fontWeight: FontWeight.bold),
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