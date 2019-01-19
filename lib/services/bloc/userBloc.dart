import 'dart:async';

import 'package:flutter/material.dart';
import 'package:friend_tracker/Model/User.dart';
import 'package:location/location.dart';

class UserBloc {
  User user;

  StreamController<User> _userController = StreamController<User>();

  StreamSink<User> get _inUser => _userController.sink;

  Stream<User> get _outUser => _userController.stream;


  UserBloc(){
    user=new User();
    _userController.stream.listen(handleUser);
  }

  void handleUser(User user) {
    _inUser.add(user);
  }

  void dispose() {
    _userController.close();
  }
}
