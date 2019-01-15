import 'package:flutter/material.dart';
import 'package:friend_tracker/services/authentication.dart';

class AuthInheritedWidget extends InheritedWidget{
  final BaseAuth auth;

  AuthInheritedWidget({Key key,this.auth,child}):super(key:key,child:child);
  static AuthInheritedWidget of(BuildContext context){
    return context.inheritFromWidgetOfExactType(AuthInheritedWidget);
  }
  @override
  bool updateShouldNotify(AuthInheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return oldWidget.auth!=auth;
  }

}