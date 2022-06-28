import 'package:flutter/material.dart';
import 'pages/main_page.dart';
import 'pages/SignUpScreen.dart';
import 'package:drivesafev2/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/SignUpLoadScreen.dart';
import 'pages/LogInPage.dart';
import 'pages/ContactsScreen/FriendsScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Nunito",
      ),
      debugShowCheckedModeBanner: false,
      home: mainPage(),
      routes: {
        "mainPage": ((context) => mainPage()),
        "SignUpPage": ((context) => SignUpScreen()),
        "LogInPage": ((context) => LogInScreen()),
        "FriendSreen": ((context) => FriendScreen())
      },
    );
  }
}
