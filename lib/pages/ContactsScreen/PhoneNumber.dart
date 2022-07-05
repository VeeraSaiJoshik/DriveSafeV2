import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/User.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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
  @override
  int counter = 0;
  int index = 0;
  int highest = 0;
  late List answer = [];
  late List<String> tempList2 = [];
  List<Color> colorList1 = [Colors.blue, Colors.grey.shade300];
  List<Color> colorTextList1 = [Colors.grey.shade300, Colors.blue];
  List<Color> colorList2 = [Colors.grey.shade300, Colors.blue];
  List<Color> colorTextList2 = [Colors.blue, Colors.grey.shade300];
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
                                    answer = [];
                                  }),
                                  child: Container(
                                    height: widget.height * (0.06),
                                    width: widget.width * (0.82 / 2),
                                    child: Center(
                                      child: Text("Contact List",
                                          style: TextStyle(
                                              color: colorList2[counter],
                                              fontWeight: FontWeight.w700,
                                              fontSize: widget.textSize * 20)),
                                    ),
                                    decoration: BoxDecoration(
                                        color: colorList1[counter],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100))),
                                  ),
                                ),
                                InkWell(
                                    onTap: () => setState(() {
                                          counter = 1;
                                          answer = [];
                                        }),
                                    child: Container(
                                      height: widget.height * (0.06),
                                      width: widget.width * (0.82 / 2),
                                      child: Center(
                                        child: Text("Added Contacts",
                                            style: TextStyle(
                                                color: colorList1[counter],
                                                fontWeight: FontWeight.w700,
                                                fontSize:
                                                    widget.textSize * 20)),
                                      ),
                                      decoration: BoxDecoration(
                                          color: colorList2[counter],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100))),
                                    )),
                              ])),
                      SizedBox(height: widget.height * 0.04)
                    ],
                  ),
                )
              ],
            )));
  }
}
