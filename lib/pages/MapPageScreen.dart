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
  List<Timer> timers = [];
  List<List> locations = [];
  void initState() {
    print(widget.LocationSharingUsers.length);

    for (int i = 0; i < widget.LocationSharingUsers.length; i++) {
      locations.add([]);
    }
    for (int i = 0; i < widget.LocationSharingUsers.length; i++) {
      timers.add(Timer.periodic(const Duration(seconds: 1), (Timer t) async {
        await FirebaseDatabase.instance
            .ref("User")
            .child(widget.LocationSharingUsers[i])
            .child("location")
            .get()
            .then((value) {
          setState(() {
            locations[i] = value.value as List;
          });
        });
        print(locations);
        print("here");
      }));
    }
    super.initState();
  }

  @override
  void dispose() {
    for (int k = 0; k < timers.length; k++) {
      timers[k].cancel();
    }
    super.dispose();
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
