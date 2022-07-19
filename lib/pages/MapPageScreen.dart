import 'package:flutter/material.dart';
import 'package:drivesafev2/models/User.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class MapPageScreen extends StatefulWidget {
  @override
  User currentUser;
  List<String> LocationSharingUsers;

  MapPageScreen(this.currentUser, this.LocationSharingUsers);
  _MapPageScreenState createState() => _MapPageScreenState();
}

class _MapPageScreenState extends State<MapPageScreen> {
  @override
  List<DatabaseReference> listeners = [];
  void initState() {
    for (int i = 0; i < widget.LocationSharingUsers.length; i++) {
      FirebaseDatabase.instance
          .ref("User/" + widget.LocationSharingUsers[i] + "/location")
          .onValue
          .listen((event) {
        print(event.snapshot.value);
      });
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
          child: FloatingActionButton(
        child: Text("this si the map scren"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )),
    );
  }
}

class LocationSharingUsers {}
