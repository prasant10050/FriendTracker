import 'dart:async';

import 'package:flutter/material.dart';
import 'package:friend_tracker/views/splashScreen/splashScreenC.dart';
class SplashScreenB extends StatefulWidget {
  @override
  _SplashScreenBState createState() => _SplashScreenBState();
}

class _SplashScreenBState extends State<SplashScreenB> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(
          seconds: 1,
        ),
            (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>new SplashScreenC()));
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
                colors: [Color(0xff29dfb7),Color(0xff3ec7fd),],
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
                  Icons.location_searching,
                  color: Colors.deepOrange,
                  size: 50.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0,),
              ),
              Text(
                "Searching",
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
