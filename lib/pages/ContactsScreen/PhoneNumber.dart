import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
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
  List<Contact> answer = [];
  List<Contact> contacts = [];
  List<Contact> contactFriends = [];
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

  getAllContacts() async {
    List<Contact> currentcontacts = await ContactsService.getContacts(
        withThumbnails: false, iOSLocalizedLabels: true);
    for (int i = 0; i < currentcontacts.length; i++) {
      bool flag = false;
      if (currentcontacts[i].phones != null) {
        if (currentcontacts[i].phones!.isNotEmpty) {
          contacts.add(currentcontacts[i]);
        }
      } else if (currentcontacts[i].phones!.isEmpty) {
        continue;
      } else if (currentUser.numberList
          .contains(currentcontacts[i].identifier)) {
        contactFriends.add(currentcontacts[i]);
      } else {
        contacts.add(currentcontacts[i]);
      }
    }
    setState(() {
      contactFriends;
      currentcontacts;
      contacts = [];
      bool galf = false;
      int val = 0;
      for (int i = 0; i < currentcontacts.length; i++) {
        if (!(currentcontacts[i].phones!.isEmpty)) {
          if (currentcontacts[i].displayName != null) {
            contacts.add(currentcontacts[i]);
          }
        }
      }
      answer = contactFriends;
    });
  }

  void collectData() async {
    await getUserData(widget.currentUser.phoneNumber)
        .then((value) => setState(() => currentUser = value))
        .whenComplete(() async {
      await getAllContacts();
    });
  }

  void initFunction() async {
    collectData();
  }

  void initState() {
    initFunction();
    print(contacts);
    for (int i = 0; i < contacts.length; i++) {
      print(contacts[i].phones![0].value);
    }
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
                        Container(
                          width: widget.width,
                          height: widget.height * 0.804,
                          child: Scrollbar(
                            thickness: 10,
                            radius: Radius.circular(50),
                            isAlwaysShown: true,
                            child: ListView(children: [
                              ...answer
                                  .map((user) => Column(
                                        children: [
                                          Neumorphic(
                                            style: NeumorphicStyle(
                                                boxShape: NeumorphicBoxShape
                                                    .roundRect(
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                45))),
                                                depth: 15,
                                                color: Colors.grey.shade300,
                                                lightSource:
                                                    LightSource.topLeft,
                                                shape: NeumorphicShape.concave),
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: widget.width * 0.95,
                                              height: widget.height * 0.16,
                                              color: Colors.grey.shade300,
                                              child: Row(
                                                children: [
                                                  user.avatar == null
                                                      ? Neumorphic(
                                                          style: const NeumorphicStyle(
                                                              boxShape:
                                                                  NeumorphicBoxShape
                                                                      .circle(),
                                                              border: NeumorphicBorder(
                                                                  width: 5,
                                                                  color: Colors
                                                                      .blue),
                                                              depth: -10),
                                                          child: CircleAvatar(
                                                              radius: widget
                                                                      .height *
                                                                  0.065,
                                                              backgroundColor:
                                                                  Colors.grey
                                                                      .shade300),
                                                        )
                                                      : CircleAvatar(),
                                                  Text(
                                                    user.displayName!,
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize:
                                                          widget.textSize * 25,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: widget.height * 0.02)
                                        ],
                                      ))
                                  .toList()
                            ]),
                          ),
                        )
                      ]),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          padding: EdgeInsets.symmetric(
                              vertical: widget.height * 0.005,
                              horizontal: widget.width * 0.02),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () => setState(() {
                                          counter = 0;
                                          answer = contactFriends;
                                          print(counter);
                                        }),
                                    child: Container(
                                      height: widget.height * (0.06),
                                      width: widget.width * (0.82 / 2),
                                      child: Center(
                                        child: Text("Approved",
                                            style: TextStyle(
                                                color: colorList2[counter],
                                                fontWeight: FontWeight.w700,
                                                fontSize:
                                                    widget.textSize * 20)),
                                      ),
                                      decoration: BoxDecoration(
                                          color: colorList1[counter],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100))),
                                    )),
                                InkWell(
                                  onTap: () => setState(() {
                                    counter = 1;
                                    answer = contacts;
                                  }),
                                  child: Container(
                                    height: widget.height * (0.06),
                                    width: widget.width * (0.82 / 2),
                                    child: Center(
                                      child: Text("All Contacts",
                                          style: TextStyle(
                                              color: colorList1[counter],
                                              fontWeight: FontWeight.w700,
                                              fontSize: widget.textSize * 20)),
                                    ),
                                    decoration: BoxDecoration(
                                        color: colorList2[counter],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100))),
                                  ),
                                ),
                              ])),
                      SizedBox(height: widget.height * 0.04)
                    ],
                  ),
                )
              ],
            )));
  }
}
