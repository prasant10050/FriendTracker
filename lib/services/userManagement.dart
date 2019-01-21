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
  Future<String> updateUserLocation(String userId,Map<String,double> ulocation,String datetime);
}
class UserDatabase implements BaseDatabase{
  DatabaseReference databaseReference=FirebaseDatabase.instance.reference();
  User user;
  UserDatabase(){
    databaseReference.keepSynced(true);
    FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000);
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  }
  @override
  Future<String> addNewUser(String userId,User user) async{
   /* this.user=user;
    var encodeUser = jsonEncode(this.user);
    print(encodeUser.toString());*/
    String newUserStatus="failure";
    newUserStatus=await databaseReference.child('users').child(userId).set(user.toJson()).then((v){
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
  Future<List<User>> searchAllUser(){
    //databaseReference.child("users");
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
  Future<String> updateUserLocation(String userId, Map ulocation,String datetime) async{
    String newUserStatus="failure";
    newUserStatus=await databaseReference.child('users').child(userId).child("location").set(ulocation).then((v){
      databaseReference.child('users').child(userId).child("datetime").set(datetime);
      return "Success";
    });
    return newUserStatus;
    // TODO: implement updateUserLocation
    return null;
  }

}