import 'dart:io';

class User {
  String firstName;
  String lastName;
  String phoneNumber;
  String password;
  int age;
  List friends;
  List friendRequests;
  List location;
  String image;
  /* bool numberApproved;
  bool locationTrackingOn;
  List numberList;*/

  User(
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.age,
      this.friendRequests,
      this.friends,
      this.location,
      this.image,
      this.password);
}
