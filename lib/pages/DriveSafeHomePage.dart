import 'package:flutter/material.dart';
import 'package:drivesafev2/models/User.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lottie/lottie.dart';

class DriveSafeHomePage extends StatefulWidget {
  User UserProfile;
  DriveSafeHomePage(this.UserProfile);

  @override
  _DriveSafeHomePageState createState() => _DriveSafeHomePageState();
}

class _DriveSafeHomePageState extends State<DriveSafeHomePage> with SingleTickerProviderStateMixin{
  @override
  
  late final AnimationController controller;

  void inistState(){
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    super.initState();
  }

  void dispose(){

  }
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String fullName;
    double textSize = MediaQuery.of(context).textScaleFactor;
    Color mainColor = Colors.grey.shade300;
    
    return Scaffold(
        backgroundColor: mainColor,
        body: Center(
            child: Container(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.03,
              ),
              Neumorphic(
                style: NeumorphicStyle(
                    boxShape: NeumorphicBoxShape.circle(),
                    depth: 10,
                    shadowLightColor: Color.fromARGB(255, 193, 217, 221),
                    intensity: 1,
                    border: NeumorphicBorder(
                        color: Colors.blue, width: height * 0.01)),
                child: CircleAvatar(
                  radius: height * 0.168,
                  backgroundImage: NetworkImage(widget.UserProfile.image),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Text(
                widget.UserProfile.firstName +
                    " " +
                    widget.UserProfile.lastName,
                style: TextStyle(
                  fontSize: textSize * 35,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w800,
                  shadows: [
                    const Shadow(
                        offset: Offset(1.5, 1.5),
                        color: Colors.black38,
                        blurRadius: 10),
                    Shadow(
                        offset: Offset(-1.5, -1.5),
                        color: Colors.white.withOpacity(0.85),
                        blurRadius: 10)
                  ],
                  color: Colors.blue,
                ),
              ),
              SizedBox(
                height: height * 0.015,
              ),
              Container(
                  width: width * 0.9,
                  height: height * 0.535,
                  child: Column(children: [
                    Row(
                      children: [
                        Container(
                          width: width * (0.9 - 0.025) / 2,
                          height: height * 0.46 / 2,
                          child: NeumorphicButton(
                            onPressed: () {},
                            child: Stack(
                              children: [
                                Container(
                                  width: width * (0.9 - 0.025) / 2,
                                  child: Lottie.network(
                                      "https://assets6.lottiefiles.com/private_files/lf30_uvrwjrrs.json"),
                                  height: height * 0.16,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: width * (0.95 - 0.05) / 2,
                                      height: height * 0.13854,
                                    ),
                                    Text(
                                      "Contacts",
                                      style: TextStyle(
                                          color: mainColor,
                                          fontSize: textSize * 30,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ) //https://assets6.lottiefiles.com/packages/lf20_ligemumo.json
                              ],
                            ),
                            style: NeumorphicStyle(
                                depth: 5,
                                color: Colors.blue,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.all(Radius.circular(30)))),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.025,
                        ),
                        Container(
                          width: width * (0.9 - 0.025) / 2,
                          height: height * 0.46 / 2,
                          child: NeumorphicButton(
                            onPressed: () {},
                            child: Stack(
                              children: [
                                Container(
                                  width: width * (0.95 - 0.025) / 2,
                                  child: Lottie.network(
                                      "https://assets6.lottiefiles.com/packages/lf20_ligemumo.json"),
                                  height: height * 0.16,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: width * (0.95 - 0.025) / 2,
                                      height: height * 0.13854,
                                    ),
                                    Text(
                                      "Settings",
                                      style: TextStyle(
                                          color: mainColor,
                                          fontSize: textSize * 30,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ) //
                              ],
                            ),
                            drawSurfaceAboveChild: true,
                            style: NeumorphicStyle(
                                depth: 5,
                                color: Colors.blue,
                                border: NeumorphicBorder(),
                                shadowLightColor: Colors.transparent,
                                lightSource: LightSource.topLeft,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.all(Radius.circular(30)))),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Container(
                      width: width * (0.95),
                      height: height * ((0.46 / 2) + 0.04),
                      child: NeumorphicButton(
                        onPressed: () {},
                        child: Stack(
                          children: [
                            Lottie.network(
                                "https://assets7.lottiefiles.com/temporary_files/GvQobl.json",
                                height: 300,
                                width: 300,
                                animate: true,
                                repeat: false),
                            Column(
                              children: [
                                Container(
                                  height: height * 0.17,
                                ),
                              ],
                            ) //https://assets6.lottiefiles.com/packages/lf20_ligemumo.json
                          ],
                        ),
                        style: NeumorphicStyle(
                            depth: 5,
                            color: Colors.blue,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.all(Radius.circular(30)))),
                      ),
                    ),
                    /* Container(
                        width: width * (0.95),
                        height: height * ((0.46 / 2) + 0.04),
                        child: NeumorphicButton(
                          style: NeumorphicStyle(
                              depth: 10,
                              color: Colors.blue,
                              shadowLightColor: Colors.transparent,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.all(Radius.circular(30)))),
                            child: SizedBox(
                                  width:10,
                                  child: Container(color: Colors.black),
                                  
                                  height: 10,
                                ),
                        )),*/
                  ]))
            ],
          ),
        )));
  }
}
