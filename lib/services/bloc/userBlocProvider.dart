import 'package:flutter/material.dart';
import 'package:friend_tracker/services/bloc/userBloc.dart';

class UserBlocProvider extends InheritedWidget{
  //User user;
  UserBloc userBloc=new UserBloc();
  UserBlocProvider({Key key,Widget child}):super(key:key,child:child);

  static UserBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(UserBlocProvider) as UserBlocProvider)
          .userBloc;

  @override
  bool updateShouldNotify(_) {
    // TODO: implement updateShouldNotify
    return true;
  }

}