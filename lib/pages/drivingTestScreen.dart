import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lottie/lottie.dart';

class drivingTestScreen extends StatefulWidget {
  const drivingTestScreen({Key? key}) : super(key: key);

  @override
  _drivingTestScreenState createState() => _drivingTestScreenState();
}

class _drivingTestScreenState extends State<drivingTestScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: width * 0.85,
                    height: height * 0.32,
                    child: NeumorphicButton(
                      onPressed: () {},
                      child: Stack(
                        children: [
                          Lottie.network(
                              "https://assets5.lottiefiles.com/packages/lf20_tyi61jpp.json",
                              frameRate: FrameRate.max),
                          Container(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: EdgeInsets.only(bottom: height * 0.015),
                              padding: EdgeInsets.only(
                                  left: width * 0.045,
                                  right: width * 0.045,
                                  top: width * 0.015,
                                  bottom: width * 0.015),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              child: Text(
                                "Pre-Drive Check",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).textScaleFactor *
                                            35,
                                    color: Colors.grey.shade300,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          )
                        ],
                      ),
                      style: NeumorphicStyle(
                        depth: 20,
                        border: const NeumorphicBorder(
                            color: Colors.blueAccent, width: 5),
                        color: Colors.grey.shade300,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.all(Radius.circular(45))),
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: width * 0.33,
                          height: 10,
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: height * 0.03),
                          child: Text(
                            "OR",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).textScaleFactor * 25,
                                color: Colors.blue,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        Container(
                          width: width * 0.33,
                          height: 10,
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: width * 0.85,
                    height: height * 0.32,
                    margin: EdgeInsets.only(bottom: height * 0.02),
                    child: NeumorphicButton(
                      onPressed: () {},
                      child: Stack(
                        children: [
                          Lottie.network(
                              "https://assets9.lottiefiles.com/packages/lf20_ura3rdqz.json",
                              frameRate: FrameRate.max),
                          Container(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: EdgeInsets.only(bottom: height * 0.015),
                              padding: EdgeInsets.only(
                                  left: width * 0.045,
                                  right: width * 0.045,
                                  top: width * 0.015,
                                  bottom: width * 0.015),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              child: Text(
                                "Start Drive",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).textScaleFactor *
                                            35,
                                    color: Colors.grey.shade300,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          )
                        ],
                      ),
                      style: NeumorphicStyle(
                        depth: 20,
                        border: const NeumorphicBorder(
                            color: Colors.blueAccent, width: 5),
                        color: Colors.grey.shade300,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.all(Radius.circular(45))),
                      ),
                    ),
                  ),
                ]),
            Container(
              height: height,
              alignment: Alignment.bottomCenter,
              child: Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(bottom: height * 0.03),
                  width: height * 0.1,
                  height: height * 0.1,
                  child: NeumorphicButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: const NeumorphicStyle(
                      color: Color(0xFFDF4758),
                      boxShape: NeumorphicBoxShape.circle(),
                    ),
                    child: Lottie.network(
                        "https://assets10.lottiefiles.com/packages/lf20_i0zh5psb.json",
                        repeat: false,
                        fit: BoxFit.fill
                        ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
