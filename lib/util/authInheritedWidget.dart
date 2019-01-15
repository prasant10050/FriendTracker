import 'package:flutter/material.dart';
import 'package:friend_tracker/services/authentication.dart';

class AuthInheritedWidget extends InheritedWidget{
  final BaseAuth auth;

  AuthInheritedWidget({Key key,this.auth}):super(key:key);
  static AuthInheritedWidget of(BuildContext context){
    return context.inheritFromWidgetOfExactType(AuthInheritedWidget);
  }
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

}