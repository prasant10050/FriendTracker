import 'dart:async';

import 'package:flutter/material.dart';
import 'package:friend_tracker/services/authentication.dart';
import 'package:friend_tracker/views/splashScreen/splashScreenB.dart';
class SplashScreen extends StatefulWidget {
  final BaseAuth auth;

  SplashScreen({this.auth});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
      Duration(
        seconds: 1,
      ),
        (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>new SplashScreenB()));
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: new Color(0xff622f74),
              gradient: LinearGradient(
                colors: [Color(0xff6094e8),Color(0xffde5cbc),],
                begin: Alignment.centerRight,
                end: Alignment(-1,-1),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 75.0,
                child: Icon(
                  Icons.location_city,
                  color: Colors.deepOrange,
                  size: 50.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0,),
              ),
              Text(
                "Screen A",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
