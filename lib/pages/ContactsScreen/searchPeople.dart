import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:drivesafev2/python/searchAlgorithm.dart';
import 'package:drivesafev2/models/User.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class searchPeople extends StatefulWidget {
  double height;
  double width;
  var textSize;
  TextEditingController textEditingController;
  User currentUser;
  searchPeople(this.height, this.width, this.textEditingController,
      this.textSize, this.currentUser);

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
  List friends = [];
  List friendRequests = [];
  List LocationSharingPeople = [];
  List friendRequestsPending = [];
  List location = [];
  List numberList = [];
  List chosenNumber = [];
  List<String> phoneNumberSearchList = [];
  late User currentUser =
      User(" ", " ", " ", " ", 0, [], [], [], [], [], "", false, false, []);
  late List<User> allusers = [];
  bool flag = false;
  Future<User> getUserData(String phoneNumber) async {
    phoneNumber = phoneNumber.trim();
    phoneNumber = phoneNumber.replaceAll(" ", "");
    if (phoneNumber[0] != "+") {
      phoneNumber = "+1" + phoneNumber;
    }
    final Data =
        await FirebaseDatabase.instance.ref("User/" + phoneNumber).get();
    Map data = Data.value as Map;
    print(data);
    if (data.containsKey("friends")) {
      friends.addAll(data["friends"]);
      print(friends);
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
    await getData().then((users) {
      setState(() {
        allusers.addAll(users);
        for (int i = 0; i < allusers.length; i++) {
          allDisplayNames
              .add(allusers[i].firstName + " " + allusers[i].lastName);
          phoneNumberSearchList.add(allusers[i].phoneNumber);
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
      });
    });
    for (int i = 0; i < allusers.length; i++) {
      answer.add(i);
    }
    await getUserData(widget.currentUser.phoneNumber).then((value) {
      setState(() {
        currentUser = value;
      });
    });
  }

  void initState() {
    collectData();
    print(friends);
    super.initState();
  }

  Widget build(BuildContext context) {
    double textSize = MediaQuery.of(context).textScaleFactor;
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
                          List<String> dummy = allDisplayNames;
                          flag = true;
                          print("=============================");
                          print(allusers.length);
                          answer = searchNames(tempList2, text, highest, flag);
                          print(answer.length);
                          print(tempList2.length);
                          print(text);
                          if (allusers.length == answer.length ||
                              answer.isEmpty) {
                            if (text != "") {
                              answer = [];
                              print(searchPhoneNumbers(
                                  phoneNumberSearchList, text, flag));
                              answer.addAll(searchPhoneNumbers(
                                  phoneNumberSearchList, text, flag));
                              print(answer);
                            }
                          }
                          setState(() {});
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
              height: widget.height * 0.80,
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
                        User user = allusers[userArea];
                        User appUser = currentUser;
                        List<String> awaitList = requestList;
                        print(user.firstName);
                        print(user.image);
                        // giant code
                        Color finalColor = Colors.blue;
                        bool flag = true;
                        int index = 0;
                        for (int i = 0;
                            i < appUser.friendRequests.length;
                            i++) {
                          if (user.phoneNumber ==
                              appUser.friendRequests[i][1]) {
                            if (appUser.friendRequests[i][0] == "pending") {
                              finalColor = Colors.orange;
                            } else {
                              finalColor = Colors.red;
                            }
                            index = i;
                            break;
                          }
                        }
                        if (currentUser.friends
                            .contains(allusers[userArea].phoneNumber)) {
                          finalColor = Colors.green;
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
                                if (user.phoneNumber == appUser.phoneNumber) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.ERROR,
                                    animType: AnimType.SCALE,
                                    headerAnimationLoop: false,
                                    title: "ERROR",
                                    desc:
                                        "You cannot send a contact-request to yourself",
                                    titleTextStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Nunito",
                                      fontSize: textSize * 25,
                                      color: Colors.red,
                                    ),
                                    descTextStyle: TextStyle(
                                        fontFamily: "Nunito",
                                        fontSize: textSize * 20,
                                        color: Colors.red),
                                    btnOkOnPress: () {},
                                    btnOkText: "Ok",
                                    btnOkColor: Colors.red,
                                  ).show();
                                } else if (color == Colors.green) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.ERROR,
                                    animType: AnimType.SCALE,
                                    headerAnimationLoop: false,
                                    title: "ERROR",
                                    desc:
                                        "The chosen user is already your friend. You can not send requests to your friend",
                                    titleTextStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Nunito",
                                      fontSize: textSize * 25,
                                      color: Colors.red,
                                    ),
                                    descTextStyle: TextStyle(
                                        fontFamily: "Nunito",
                                        fontSize: textSize * 20,
                                        color: Colors.red),
                                    btnOkOnPress: () {},
                                    btnOkText: "Ok",
                                    btnOkColor: Colors.red,
                                  ).show();
                                } else if (color == Colors.orange) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.ERROR,
                                    animType: AnimType.SCALE,
                                    headerAnimationLoop: false,
                                    title: "ERROR",
                                    desc:
                                        "You have already sent a friend request to the person. The request is currently pending.",
                                    titleTextStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Nunito",
                                      fontSize: textSize * 25,
                                      color: Colors.red,
                                    ),
                                    descTextStyle: TextStyle(
                                        fontFamily: "Nunito",
                                        fontSize: textSize * 20,
                                        color: Colors.red),
                                    btnOkOnPress: () {},
                                    btnOkText: "Ok",
                                    btnOkColor: Colors.red,
                                  ).show();
                                } else {
                                  AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.INFO,
                                          animType: AnimType.SCALE,
                                          headerAnimationLoop: false,
                                          title: "Warning",
                                          desc:
                                              "Are you sure you want to send a friend request to " +
                                                  allusers[userArea].firstName +
                                                  " " +
                                                  allusers[userArea].lastName,
                                          titleTextStyle: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Nunito",
                                            fontSize: textSize * 25,
                                            color: Colors.blue,
                                          ),
                                          descTextStyle: TextStyle(
                                              fontFamily: "Nunito",
                                              fontSize: textSize * 20,
                                              color: Colors.blueAccent),
                                          btnOkOnPress: () async {
                                            for (int k = 0;
                                                k <
                                                    appUser
                                                        .friendRequests.length;
                                                k++) {
                                              if (appUser.friendRequests[k]
                                                      [1] ==
                                                  user.phoneNumber) {
                                                appUser.friendRequests
                                                    .removeAt(k);
                                              }
                                            }
                                            setState(() {
                                              appUser.friendRequests.add([
                                                "pending",
                                                user.phoneNumber
                                              ]);
                                              answer = answer;
                                            });
                                            // code
                                            await FirebaseDatabase.instance
                                                .ref("User")
                                                .update({
                                              appUser.phoneNumber: {
                                                "age": appUser.age,
                                                "firstName": appUser.firstName,
                                                "lastName": appUser.lastName,
                                                "friendReqeusts":
                                                    appUser.friendRequests,
                                                "friendRequestsPending": appUser
                                                    .friendRequestsPending,
                                                "image": appUser.image,
                                                "password": appUser.password,
                                                "friends": appUser.friends,
                                                "location": appUser.location,
                                                "phoneNumber":
                                                    appUser.phoneNumber,
                                                "locationSharingPeople": appUser
                                                    .LocationSharingPeople,
                                                "numberApproved": false,
                                                "locationTrackingOn": false,
                                                "phoneNumbersChosen": []
                                              }
                                            });
                                            final requestUserData =
                                                await FirebaseDatabase.instance
                                                    .ref("User/")
                                                    .child(user.phoneNumber)
                                                    .child(
                                                        "friendRequestsPending")
                                                    .get();
                                            List tempFriendList = [];
                                            if (requestUserData.value != null) {
                                              List requestUserFinalData =
                                                  requestUserData.value as List;
                                              tempFriendList
                                                  .addAll(requestUserFinalData);
                                            }
                                            tempFriendList
                                                .add(appUser.phoneNumber);
                                            await FirebaseDatabase.instance
                                                .ref("User")
                                                .child(user.phoneNumber)
                                                .update({
                                              "friendRequestsPending":
                                                  tempFriendList
                                            });
                                          },
                                          btnOkText: "Yes",
                                          btnOkColor: Colors.green,
                                          btnCancelText: "No",
                                          btnCancelColor: Colors.red,
                                          btnCancelOnPress: () {})
                                      .show();
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
                                            boxShape:
                                                NeumorphicBoxShape.circle(),
                                            depth: -15,
                                            color: Colors.grey.shade300,
                                            lightSource: LightSource.topLeft,
                                            border: NeumorphicBorder(
                                                color: color, width: 5),
                                            shape: NeumorphicShape.concave),
                                        child: user.image == ""
                                            ? CircleAvatar(
                                                radius:
                                                    widget.height * (0.11 / 2),
                                                backgroundColor:
                                                    Colors.grey.shade300,
                                                child: NeumorphicIcon(
                                                  Icons.tag_faces,
                                                  size: textSize * 70,
                                                  style: NeumorphicStyle(
                                                      color: color),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  print(user.image);
                                                },
                                                child: CircleAvatar(
                                                  radius: widget.height *
                                                      (0.11 / 2),
                                                  backgroundImage:
                                                      NetworkImage(user.image),
                                                ),
                                              )),
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
