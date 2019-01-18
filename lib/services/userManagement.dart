import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:friend_tracker/Model/User.dart';
abstract class BaseDatabase{
  Future<String> addNewUser(String userId,User user);
  Future<String> deleteUser(String userId);
  Future<String> updateUser(String userId,User user);
  Future<List<User>> searchAllUser();
  Future<User> searchUser(String userId);
  Future<Map<String,double>> updateUserLocation(String userId,Map<String,double> location);
}
class UserDatabase implements BaseDatabase{
  DatabaseReference databaseReference=FirebaseDatabase.instance.reference();
  @override
  Future<String> addNewUser(String userId, User user) async{
    var encodeUser = json.encode(user);
    String newUserStatus="failure";
    newUserStatus=await databaseReference.child('users').child(userId).set(encodeUser).then((v){
      return "Success";
    });
    return newUserStatus;
  }

  @override
  Future<String> deleteUser(String userId) {
    // TODO: implement deleteUser
    return null;
  }

  @override
  Future<List<User>> searchAllUser() {
    // TODO: implement searchAllUser
    return null;
  }

  @override
  Future<User> searchUser(String userId) {
    // TODO: implement searchUser
    return null;
  }

  @override
  Future<String> updateUser(String userId, User user) {
    // TODO: implement updateUser
    return null;
  }

  @override
  Future<Map<String, double>> updateUserLocation(String userId, Map location) {
    // TODO: implement updateUserLocation
    return null;
  }

}