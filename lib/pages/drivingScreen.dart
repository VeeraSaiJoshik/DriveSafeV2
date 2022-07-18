import 'dart:async';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:drivesafev2/models/User.dart';

class DrivingScreen extends StatefulWidget {
  User currentUser;
  DrivingScreen(this.currentUser);
  @override
  _DrivingScreenState createState() => _DrivingScreenState();
}

class _DrivingScreenState extends State<DrivingScreen> {
  Timer? timer;

  int i = 0;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      i++;
      await FirebaseDatabase.instance
          .ref("User")
          .child(widget.currentUser.phoneNumber)
          .child("location")
          .set([i]);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: Center(
            child: FloatingActionButton(
          child: Text("Firebase transition"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )));
  }
}
