import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friend_tracker/services/authentication.dart';
import 'package:friend_tracker/services/connectionStatusSingleton.dart';
import 'package:friend_tracker/util/authInheritedWidget.dart';
import 'package:friend_tracker/views/ConnectionError.dart';
import 'package:friend_tracker/views/signInUp/sign_in.dart';
import 'package:friend_tracker/views/signInUp/sign_up.dart';
import 'package:friend_tracker/views/splashScreen/splashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friend Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Home Page',auth:new Auth()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title,this.auth}) : super(key: key);

  final String title;
  final BaseAuth auth;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription _connectionChangeStream;
  bool isOffline = false;
  @override
  initState() {
    super.initState();

    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: Center(
        child: (isOffline)? new ConnectionError() : new AuthInheritedWidget(auth:new Auth(),child:new SplashScreen(auth: new Auth(),)),
      ),
    );
  }
}
