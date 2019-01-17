import 'dart:async';

import 'package:flutter/material.dart';
import 'package:friend_tracker/services/authentication.dart';
import 'package:friend_tracker/services/getLocation.dart';
import 'package:friend_tracker/views/home.dart';
import 'package:friend_tracker/views/signInUp/sign_in.dart';
class SplashScreenC extends StatefulWidget {
  @override
  _SplashScreenCState createState() => _SplashScreenCState();
}

class _SplashScreenCState extends State<SplashScreenC> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(
          seconds: 2,
        ),
            (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>new HomePage(auth:new Auth())));
          //SignIn(auth: new Auth(),onSignedIn: null,)
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
                  Icons.location_on,
                  color: Colors.deepOrange,
                  size: 50.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0,),
              ),
              Text(
                "Screen C",
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
