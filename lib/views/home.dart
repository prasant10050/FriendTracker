import 'package:flutter/material.dart';
import 'package:friend_tracker/services/authentication.dart';
import 'package:friend_tracker/services/getLocation.dart';
import 'package:friend_tracker/views/signInUp/sign_in.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _HomePageState extends State<HomePage> {
  BaseAuth auth;
  AuthStatus authStatus=AuthStatus.NOT_DETERMINED;
  String _userId="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth.getCurrentUser().then((user){
      setState(() {
        if(user!=null){
          _userId=user?.uid;
        }
        authStatus=user?.uid==null?AuthStatus.NOT_LOGGED_IN:AuthStatus.LOGGED_IN;
      });
    });
  }

  void _onLoggedIn() {
    auth.getCurrentUser().then((user){
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;

    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new SignIn(
          auth: auth,
          onSignedIn: _onLoggedIn,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new GetLocation(
            userId: _userId,
            auth: auth,
            onSignedOut: _onSignedOut,
          );
        } else return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}
