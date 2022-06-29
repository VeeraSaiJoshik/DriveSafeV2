import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'searchPeople.dart';
import 'AcceptFriendScreen.dart';
import 'PhoneNumber.dart';
import 'MainFriendScreen.dart';
import 'package:drivesafev2/models/User.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({Key? key}) : super(key: key);

  @override
  _FriendScreenState createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  int index = 3;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String fullName;
    double textSize = MediaQuery.of(context).textScaleFactor;
    Color mainColor = Colors.grey.shade300;
    TextEditingController textEditingController = TextEditingController();
    List passOverData = ModalRoute.of(context)!.settings.arguments as List;
    User currentUser = passOverData[0];
    List<User> allUsers = passOverData[1];
    List<Widget> pageList = [
      MainFriendScreen(),
      PhoneNumberScreen(),
      searchPeople(height - 60, width, textEditingController, textSize,
          currentUser),
      FriendsScreen(),
    ];
    return Container(
      color: Colors.blue,
      child: SafeArea(
        top: false,
        child: ClipRect(
          child: Scaffold(
            backgroundColor: mainColor,
            body: pageList[index],
            bottomNavigationBar: CurvedNavigationBar(
              items: <Widget>[
                Icon(
                  Icons.person,
                  size: textSize * 40,
                  color: mainColor,
                ),
                Icon(
                  Icons.phone,
                  size: textSize * 40,
                  color: mainColor,
                ),
                Icon(
                  Icons.person_search,
                  size: textSize * 40,
                  color: mainColor,
                ),
                Icon(
                  Icons.person_add,
                  size: textSize * 40,
                  color: mainColor,
                ),
              ],
              onTap: (number) {
                index = number;
                setState(() {
                  index;
                });
              },
              color: Colors.blue,
              height: 60,
              backgroundColor: mainColor,
            ),
          ),
        ),
      ),
    );
  }
}
