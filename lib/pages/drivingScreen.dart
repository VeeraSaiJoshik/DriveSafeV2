import 'dart:async';
import 'package:cron/cron.dart';

import 'package:flutter/material.dart';

class DrivingScreen extends StatefulWidget {
  const DrivingScreen({Key? key}) : super(key: key);

  @override
  _DrivingScreenState createState() => _DrivingScreenState();
}

class _DrivingScreenState extends State<DrivingScreen> {
  Timer? timer;

  @override
  @override
  void initState() {
    super.initState();
    timer =
      Timer.periodic(const Duration(seconds: 10), (Timer t){
        
      });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: Center(child: Text("so yeah")));
  }
}
