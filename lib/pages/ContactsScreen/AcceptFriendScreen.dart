import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:drivesafev2/models/User.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:telephony/telephony.dart';

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
  List<Color> colorList1 = [Colors.blue, Colors.grey.shade300];
  List<Color> colorTextList1 = [Colors.grey.shade300, Colors.blue];
  List<Color> colorList2 = [Colors.grey.shade300, Colors.blue];
  List<Color> colorTextList2 = [Colors.blue, Colors.grey.shade300];
  List<List> friendsList = [];
  List requestList = [];
  List<String> friendListAnalysisList = [];
  List<String> friendListPhoneNumberList = [];
  List<String> requestListFriendAnalysisList = [];
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
            friendListPhoneNumberList.add(allusers[j].phoneNumber);
            break;
          }
        }
      }
      for (int i = 0; i < friendListAnalysisList.length; i++) {
        if (friendListAnalysisList[i].length > longestFriendListvalue) {
          longestFriendListvalue = friendListAnalysisList[i].length;
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
      for (int i = 0; i < currentUser.friendRequestsPending.length; i++) {
        for (int j = 0; j < allusers.length; j++) {
          if (allusers[j].phoneNumber == currentUser.friendRequestsPending[i]) {
            requestList.add(j);

            requestListAnalysisList
                .add(users[j].firstName + " " + users[j].lastName);
            requestListFriendAnalysisList.add(users[j].phoneNumber);
            break;
          }
        }
      }

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

      setState(() {
        requestList;
      });
      answer.addAll(requestList);
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
                                  List<String> dummy = allDisplayNames;
                                  flag = true;
                                  setState(() {
                                    List tempAns = [];
                                    if (counter == 1) {
                                      answer = searchNames(
                                          friendListAnalysisList,
                                          text,
                                          longestFriendListvalue + 1,
                                          true);
                                      if (allusers.length == answer.length ||
                                          answer.isEmpty) {
                                        if (text != "") {
                                          answer = [];
                                          answer.addAll(searchPhoneNumbers(
                                              friendListPhoneNumberList,
                                              text,
                                              flag));
                                        }
                                      }

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
                                      if (allusers.length == answer.length ||
                                          answer.isEmpty) {
                                        if (text != "") {
                                          answer = [];

                                          answer.addAll(searchPhoneNumbers(
                                              requestListFriendAnalysisList,
                                              text,
                                              flag));
                                        }
                                      }

                                      tempAns.addAll(answer);
                                      answer = [];
                                      for (int i = 0; i < tempAns.length; i++) {
                                        answer.add(requestList[tempAns[i]]);
                                      }
                                    }
                                    setState(() {
                                      answer;
                                    });
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
                            child: counter == 0
                                ? ListView(
                                    children: [
                                      ...answer.map((e) {
                                        Color color;
                                        color = Colors.orange;
                                        return Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                                                    .grey
                                                                    .shade300,
                                                                lightSource:
                                                                    LightSource
                                                                        .topLeft,
                                                                border:
                                                                    NeumorphicBorder(
                                                                        color:
                                                                            color,
                                                                        width:
                                                                            5),
                                                                shape:
                                                                    NeumorphicShape
                                                                        .concave),
                                                            child: allusers[e]
                                                                        .image ==
                                                                    ""
                                                                ? CircleAvatar(
                                                                    radius: widget
                                                                            .height *
                                                                        (0.11 /
                                                                            2),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .grey
                                                                            .shade300,
                                                                    child:
                                                                        NeumorphicIcon(
                                                                      Icons
                                                                          .tag_faces,
                                                                      size: widget
                                                                              .textSize *
                                                                          70,
                                                                      style: NeumorphicStyle(
                                                                          color:
                                                                              color),
                                                                    ),
                                                                  )
                                                                : CircleAvatar(
                                                                    radius: widget
                                                                            .height *
                                                                        0.11,
                                                                    backgroundImage:
                                                                        NetworkImage(
                                                                            allusers[e].image),
                                                                  )),
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
                                                                  fontSize:
                                                                      MediaQuery.of(context)
                                                                              .textScaleFactor *
                                                                          25),
                                                            ),
                                                            SizedBox(
                                                              height: widget
                                                                      .height *
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
                                                                      allusers[
                                                                              e]
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
                                                              answer.remove(e);
                                                            });
                                                            currentUser
                                                                .friendRequestsPending
                                                                .remove(
                                                              allusers[e]
                                                                  .phoneNumber,
                                                            );
                                                            currentUser
                                                                .numberList
                                                                .add([
                                                              allusers[e]
                                                                  .firstName,
                                                              allusers[e]
                                                                  .lastName,
                                                              allusers[e]
                                                                  .phoneNumber,
                                                              allusers[e].image,
                                                              true
                                                            ]);
                                                            final currentData =
                                                                await FirebaseDatabase
                                                                    .instance
                                                                    .ref("User")
                                                                    .get();
                                                            Map currentDataData =
                                                                currentData
                                                                        .value
                                                                    as Map;

                                                            List
                                                                theSendingFriendData =
                                                                [];
                                                            currentUser.friends
                                                                .add(allusers[e]
                                                                    .phoneNumber);
                                                            await FirebaseDatabase
                                                                .instance
                                                                .ref("User")
                                                                .child(currentUser
                                                                    .phoneNumber)
                                                                .set({
                                                              "age": currentUser
                                                                  .age,
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
                                                              "image":
                                                                  currentUser
                                                                      .image,
                                                              "password":
                                                                  currentUser
                                                                      .password,
                                                              "friends":
                                                                  currentUser
                                                                      .friends,
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
                                                                  currentUser
                                                                      .numberList
                                                            }).whenComplete(
                                                                    () async {
                                                              final finalData =
                                                                  await FirebaseDatabase
                                                                      .instance
                                                                      .ref(
                                                                          "User")
                                                                      .child(currentUser
                                                                          .phoneNumber)
                                                                      .get();
                                                              Map data =
                                                                  finalData
                                                                          .value
                                                                      as Map;
                                                              List temp = [];
                                                              List finalAnswer =
                                                                  [];

                                                              for (int i = 0;
                                                                  i < temp.length;
                                                                  i++) {
                                                                if (temp[i]
                                                                        [1] !=
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
                                                              var dataNow1 =
                                                                  await FirebaseDatabase
                                                                      .instance
                                                                      .ref(
                                                                          "User")
                                                                      .child(allusers[
                                                                              e]
                                                                          .phoneNumber)
                                                                      .get();
                                                              Map dataNow =
                                                                  dataNow1.value
                                                                      as Map;
                                                              print(dataNow);
                                                              if (dataNow
                                                                  .containsKey(
                                                                      "friends")) {
                                                                List temp2 = [];
                                                                temp2.addAll(
                                                                    dataNow[
                                                                        "friends"]);
                                                                temp2.add(
                                                                    currentUser
                                                                        .phoneNumber);
                                                                await FirebaseDatabase
                                                                    .instance
                                                                    .ref("User")
                                                                    .child(allusers[
                                                                            e]
                                                                        .phoneNumber)
                                                                    .update({
                                                                  "friends":
                                                                      temp2
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
                                                            Telephony.instance.sendSms(
                                                                to: allusers[e]
                                                                    .phoneNumber
                                                                    .substring(
                                                                        1,
                                                                        allusers[e].phoneNumber.length -
                                                                            1),
                                                                message: "Greetings this is the drive safe bot. We are writing this message to know you that you will be getting messages about the driving state of " +
                                                                    currentUser
                                                                        .firstName +
                                                                    " " +
                                                                    currentUser
                                                                        .lastName +
                                                                    ", and you will also be gettings warning about the well being of the driver, location of the driver, and many other important information about the driver and his vehicle that has to do with the dirvers safety. We request you to not share this data and use this data for the greater good. The driver trusts you with this data.",
                                                                isMultipart:
                                                                    true);
                                                          },
                                                          child: Container(
                                                            width:
                                                                widget.width *
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
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      widget.textSize *
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
                                                                    .remove(
                                                                        e)));
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
                                                              "age": currentUser
                                                                  .age,
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
                                                              "image":
                                                                  currentUser
                                                                      .image,
                                                              "password":
                                                                  currentUser
                                                                      .password,
                                                              "friends":
                                                                  friends,
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
                                                              } else {
                                                                finalAnswer
                                                                    .add([
                                                                  "rejected",
                                                                  currentUser
                                                                      .phoneNumber
                                                                ]);
                                                              }
                                                            }
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
                                                            List
                                                                phoneNumberList =
                                                                allusers[e]
                                                                    .numberList;
                                                            for (int i = 0;
                                                                i <
                                                                    phoneNumberList
                                                                        .length;
                                                                i++) {
                                                              if (phoneNumberList[
                                                                  i][2]) {
                                                                phoneNumberList
                                                                    .removeAt(
                                                                        i);
                                                                break;
                                                              }
                                                            }
                                                            await FirebaseDatabase
                                                                .instance
                                                                .ref("User")
                                                                .child(allusers[
                                                                        e]
                                                                    .phoneNumber)
                                                                .child(
                                                                    "phoneNumbersChosen")
                                                                .set(
                                                                    phoneNumberList);
                                                          },
                                                          child: Container(
                                                            width:
                                                                widget.width *
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
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      widget.textSize *
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
                                                    shape: NeumorphicShape
                                                        .concave),
                                              ),
                                            ));
                                      }).toList(),
                                      SizedBox(
                                          height: widget.height * 0.2,
                                          width: widget.width)

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
                                                              LightSource
                                                                  .topLeft,
                                                          border:
                                                              NeumorphicBorder(
                                                                  color: color,
                                                                  width: 5),
                                                          shape: NeumorphicShape
                                                              .concave),
                                                      child:
                                                          allusers[e[1]]
                                                                      .image ==
                                                                  ""
                                                              ? CircleAvatar(
                                                                  radius: widget
                                                                          .height *
                                                                      (0.11 /
                                                                          2),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .grey
                                                                          .shade300,
                                                                  child:
                                                                      NeumorphicIcon(
                                                                    Icons
                                                                        .tag_faces,
                                                                    size: widget
                                                                            .textSize *
                                                                        70,
                                                                    style: NeumorphicStyle(
                                                                        color:
                                                                            color),
                                                                  ),
                                                                )
                                                              : CircleAvatar(
                                                                  radius: widget
                                                                          .height *
                                                                      (0.11 /
                                                                          2),
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          allusers[e[1]]
                                                                              .image),
                                                                ),
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
                                                              allusers[e[1]]
                                                                      .firstName +
                                                                  " " +
                                                                  allusers[e[1]]
                                                                      .lastName,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: color,
                                                                  fontSize:
                                                                      MediaQuery.of(context)
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
                                                    shape: NeumorphicShape
                                                        .concave),
                                              ),
                                            ));
                                      }).toList(),
                                      SizedBox(
                                          height: widget.height * 0.2,
                                          width: widget.width)

                                      //=> Text(allusers[e[1]].phoneNumber)
                                    ],
                                  )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: widget.width,
              height: widget.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: widget.width * 0.9,
                      height: widget.height * 0.07,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 3),
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      padding: EdgeInsets.symmetric(
                          vertical: widget.height * 0.005,
                          horizontal: widget.width * 0.02),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => setState(() {
                                counter = 0;
                                answer = [];
                                answer.addAll(requestList);
                              }),
                              child: Container(
                                height: widget.height * (0.06),
                                width: widget.width * (0.82 / 2),
                                child: Center(
                                  child: Text("Pending",
                                      style: TextStyle(
                                          color: colorList2[counter],
                                          fontWeight: FontWeight.w700,
                                          fontSize: widget.textSize * 20)),
                                ),
                                decoration: BoxDecoration(
                                    color: colorList1[counter],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                              ),
                            ),
                            InkWell(
                                onTap: () => setState(() {
                                      counter = 1;
                                      answer = [];
                                      answer.addAll(friendsList);
                                    }),
                                child: Container(
                                  height: widget.height * (0.06),
                                  width: widget.width * (0.82 / 2),
                                  child: Center(
                                    child: Text("Sent",
                                        style: TextStyle(
                                            color: colorList1[counter],
                                            fontWeight: FontWeight.w700,
                                            fontSize: widget.textSize * 20)),
                                  ),
                                  decoration: BoxDecoration(
                                      color: colorList2[counter],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                )),
                          ])),
                  SizedBox(height: widget.height * 0.04)
                ],
              ),
            )
          ],
        ));
  }
}
//down