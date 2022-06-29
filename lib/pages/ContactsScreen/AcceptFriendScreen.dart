import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:drivesafev2/models/User.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

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
  List<String> allDisplayNames = [];
  int highest = 0;
  late List<int> answer = [];
  late List<String> tempList2 = [];
  List<List> friendsList = [];
  List<int> requestList = [];
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
    List friends = [];
    List friendRequests = [];
    List LocationSharingPeople = [];
    List friendRequestsPending = [];
    List location = [];
    List numberList = [];
    List chosenNumber = [];
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

  List friends = [];
  List friendRequests = [];
  List LocationSharingPeople = [];
  List friendRequestsPending = [];
  List location = [];
  List numberList = [];
  List chosenNumber = [];
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
            friendsList.add(["pending", j]);
            break;
          }
        }
      }
      setState(() {
        friendsList;
      });
      for (int i = 0; i < currentUser.friendRequestsPending.length; i++) {
        for (int j = 0; j < allusers.length; j++) {
          if (allusers[j].phoneNumber == currentUser.friendRequestsPending[i]) {
            requestList.add(j);
            break;
          }
        }
      }
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
                            print(friendsList);
                            /*  print(allusers);
                          List<String> dummy = allDisplayNames;
                          setState(() {
                            answer = searchNames(tempList2, text, highest);
                          });
                          print("why");
                          print(answer);*/
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
                height: widget.height * 0.5,
                width: widget.width,
                child: ListView(
                  children: [
                    ...requestList.map((e) {
                      Color color;
                      color = Colors.orange;
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          height: widget.height * 0.23,
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.025,
                              right: MediaQuery.of(context).size.width * 0.025,
                              bottom: widget.height * 0.02),
                          //   color: Colors.black,
                          child: InkWell(
                            child: Neumorphic(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                        child: Container(
                                            height: widget.height * 0.11,
                                            width: widget.height * 0.11,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100)),
                                            )),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            allusers[e].phoneNumber,
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
                                                allusers[e].firstName +
                                                    " " +
                                                    allusers[e].lastName,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: color,
                                                    fontSize: MediaQuery.of(
                                                                context)
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      NeumorphicButton(
                                        onPressed: () async {
                                          currentUser.friendRequestsPending
                                              .remove(
                                            allusers[e].phoneNumber,
                                          );
                                          friends.add(allusers[e].phoneNumber);
                                          await FirebaseDatabase.instance
                                              .ref("User")
                                              .child(currentUser.phoneNumber)
                                              .set({
                                            "age": currentUser.age,
                                            "firstName": currentUser.firstName,
                                            "lastName": currentUser.lastName,
                                            "friendReqeusts":
                                                currentUser.friendRequests,
                                            "friendRequestsPending": currentUser
                                                .friendRequestsPending,
                                            "image": currentUser.image,
                                            "password": currentUser.password,
                                            "friends": friends,
                                            "location": currentUser.location,
                                            "phoneNumber":
                                                currentUser.phoneNumber,
                                            "locationSharingPeople": currentUser
                                                .LocationSharingPeople,
                                            "numberApproved": false,
                                            "locationTrackingOn": false,
                                            "phoneNumbersChosen": []
                                          }).whenComplete(() async {
                                            final finalData =
                                                await FirebaseDatabase.instance
                                                    .ref("User")
                                                    .child(
                                                        allusers[e].phoneNumber)
                                                    .get();
                                            Map data = finalData.value as Map;
                                            print(data);
                                            List temp = [];
                                            List finalAnswer = [];
                                            print("before jere");
                                            temp.addAll(data["friendReqeusts"]);
                                            for (int i = 0;
                                                i < temp.length;
                                                i++) {
                                              if (temp[i][1] !=
                                                  currentUser.phoneNumber) {
                                                if (temp[i][0] == "pending") {
                                                  finalAnswer.add(temp[i]);
                                                }
                                              }
                                            }
                                            print(finalAnswer);
                                            await FirebaseDatabase.instance
                                                .ref("User")
                                                .child(allusers[e].phoneNumber)
                                                .child("friendReqeusts")
                                                .set(finalAnswer);

                                            if (data.containsKey("friends")) {
                                              List temp2 = [];
                                              temp2.addAll(data["friends"]);
                                              temp2
                                                  .add(currentUser.phoneNumber);
                                              await FirebaseDatabase.instance
                                                  .ref("User")
                                                  .child(
                                                      allusers[e].phoneNumber)
                                                  .update({"friends": temp2});
                                            } else {
                                              await FirebaseDatabase.instance
                                                  .ref("User")
                                                  .child(
                                                      allusers[e].phoneNumber)
                                                  .child("friends")
                                                  .set([
                                                currentUser.phoneNumber
                                              ]);
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: widget.width * 0.28,
                                          height: widget.height * 0.025,
                                          child: Center(
                                            child: Text(
                                              "Accept",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: widget.textSize * 16,
                                                fontFamily: "Nunito",
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                          ),
                                        ),
                                        style: const NeumorphicStyle(
                                            depth: 0,
                                            color: Colors.lightGreen,
                                            boxShape:
                                                NeumorphicBoxShape.stadium(),
                                            shape: NeumorphicShape.concave),
                                      ),
                                      NeumorphicButton(
                                        onPressed: () {},
                                        child: Container(
                                          width: widget.width * 0.28,
                                          height: widget.height * 0.025,
                                          child: Center(
                                            child: Text(
                                              "Decline",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: widget.textSize * 16,
                                                fontFamily: "Nunito",
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                          ),
                                        ),
                                        style: const NeumorphicStyle(
                                            depth: 0,
                                            color: Colors.redAccent,
                                            boxShape:
                                                NeumorphicBoxShape.stadium(),
                                            shape: NeumorphicShape.concave),
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
                    }).toList(),
                    //=> Text(allusers[e[1]].phoneNumber)
                    ...friendsList
                        .map((e) => Text(
                            allusers[e[1]].firstName + allusers[e[1]].lastName))
                        .toList(),
                  ],
                ))
          ],
        ));
  }
}
