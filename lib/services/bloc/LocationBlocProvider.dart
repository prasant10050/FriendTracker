import 'package:flutter/material.dart';
import 'package:friend_tracker/services/bloc/locationBloc.dart';

class LocationBlocProvider extends InheritedWidget{
  //User user;
  LocationBloc locationBloc=new LocationBloc();
  LocationBlocProvider({Key key,Widget child}):super(key:key,child:child);

  static LocationBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(LocationBlocProvider) as LocationBlocProvider).locationBloc;

  @override
  bool updateShouldNotify(_) {
    // TODO: implement updateShouldNotify
    return true;
  }

}