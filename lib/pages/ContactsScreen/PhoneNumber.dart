import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/User.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:firebase_database/firebase_database.dart';

class PhoneNumberScreen extends StatefulWidget {
  double height;
  double width;
  double textSize;
  User currentUser;
  TextEditingController textEditingController;
  PhoneNumberScreen(this.height, this.width, this.textEditingController,
      this.textSize, this.currentUser,
      {Key? key})
      : super(key: key);
  @override
  _PhoneNumberScreenState createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  int counter = 0;
  int index = 0;
  int highest = 0;
  List<String> tempList2 = [];
  List<Color> colorList1 = [Colors.blue, Colors.grey.shade300];
  List<Color> colorTextList1 = [Colors.grey.shade300, Colors.blue];
  List<Color> colorList2 = [Colors.grey.shade300, Colors.blue];
  List<Color> colorTextList2 = [Colors.blue, Colors.grey.shade300];
  List phoneNumberList = [];
  late User currentUser =
      User(" ", " ", " ", " ", 0, [], [], [], [], [], "", false, false, []);
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

  void collectData() async {
    await getUserData(widget.currentUser.phoneNumber)
        .then((value) => setState(() => currentUser = value));
  }

  void initFunction() async {
    collectData();
  }

  void initState() {
    initFunction();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Center(
        child: Container(
            width: widget.width,
            height: widget.height,
            child: Stack(
              children: [
                Container(
                  width: widget.width,
                  height: widget.height,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      style: TextStyle(
                                          fontSize: widget.textSize * 30,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.blue),
                                      textAlign: TextAlign.center,
                                      onChanged: (text) {},
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
                                        const BorderRadius.all(
                                            Radius.circular(100))),
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
                      ]),
                ),
                Container(
                  width: widget.width,
                  height: widget.height,
                  
                )
              ],
            )));
  }
}
