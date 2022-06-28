import 'dart:io';

class User {
  String firstName;
  String lastName;
  String phoneNumber;
  String password;
  int age;
  List friends;
  List friendRequests;
  List LocationSharingPeople;
  List friendRequestsPending;
  List location;
  String image;
  bool numberApproved;
  bool locationTrackingOn;
  List numberList;
  User(
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.password,
      this.age,
      this.friends,
      this.friendRequests,
      this.friendRequestsPending,
      this.LocationSharingPeople,
      this.location,
      this.image,
      this.numberApproved,
      this.locationTrackingOn,
      this.numberList,
      );
}
