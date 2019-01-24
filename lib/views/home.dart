import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friend_tracker/services/authentication.dart';
import 'package:friend_tracker/services/getLocation.dart';
import 'package:friend_tracker/util/loaders/color_loader_3.dart';
import 'package:friend_tracker/views/signInUp/sign_in.dart';

class HomePage extends StatefulWidget {
  final BaseAuth auth;

  HomePage({this.auth});

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
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user?.uid != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
    //FirebaseAuth.instance.onAuthStateChanged.listen(_handleUser);
  }
  void _handleUser(FirebaseUser event) {
    setState(() {
      authStatus=event.uid==null?AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      _userId=event.uid.toString();
      //authStatus=_userId == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
    });
    //onSignedOut();
  }

  void onLoggedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user.uid != null) {
          _userId = user?.uid;
        }
        //_userId = user?.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void onSignedOut() {
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

  /*I am using a StreamBuilder with onAuthStateChanged as a stream. I also have this issue,
  onAuthStateChanged seems not to be always called after the authentication state is changed.
  Sometimes yes, sometimes no.
  */

  Widget _handleStreamCurrentScreen() {
    return new StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          /*if (snapshot.connectionState == ConnectionState.waiting) {
            return new ColorLoader3(
              radius: 15.0,
              dotRadius: 6.0,
            );
          } else {*/
            if (snapshot.hasData) {
              switch (authStatus) {
                case AuthStatus.NOT_DETERMINED:
                  return _buildWaitingScreen();
                  break;
                case AuthStatus.NOT_LOGGED_IN:
                  return new SignIn(
                    auth: widget.auth,
                    onSignedIn: onLoggedIn,
                  );
                  break;
                case AuthStatus.LOGGED_IN:
                  if ((_userId.length > 0 && _userId != null)){
                    return new GetLocation(
                      userId: _userId,
                      auth: widget.auth,
                      onSignedOut: onSignedOut,
                    );
                  } else return _buildWaitingScreen();
                  break;
                default:
                  return _buildWaitingScreen();
              }
            }
          //}
        });
  }

  Widget _handleCurrentScreen(){
    return new FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        /*if(snapshot.connectionState==ConnectionState.waiting){
          return new ColorLoader3(
            radius: 15.0,
            dotRadius: 6.0,
          );
        }else{*/
          if (snapshot.hasData) {
            if(snapshot.data.uid!=null){
              switch (authStatus) {
                case AuthStatus.NOT_DETERMINED:
                  return _buildWaitingScreen();
                  break;
                case AuthStatus.NOT_LOGGED_IN:
                  return new SignIn(
                    auth: widget.auth,
                    onSignedIn: onLoggedIn,
                  );
                  break;
                case AuthStatus.LOGGED_IN:
                  if ((snapshot.data.uid.length > 0 && snapshot.data.uid != null)){
                    return new GetLocation(
                      userId: snapshot.data.uid,
                      auth: widget.auth,
                      onSignedOut: onSignedOut,
                    );
                  } else return _buildWaitingScreen();
                  break;
                default:
                  return _buildWaitingScreen();
              }
            }else{
              return new SignIn(
                auth: widget.auth,
                onSignedIn: onLoggedIn,
              );
            }
          }else if(!snapshot.hasData){
            return new SignIn(
              auth: widget.auth,
              onSignedIn: onLoggedIn,
            );
          }
        //}
      },
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
          auth: widget.auth,
          onSignedIn: onLoggedIn,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if ((_userId.length > 0 && _userId != null)){
          return new GetLocation(
            userId: _userId,
            auth: widget.auth,
            onSignedOut: onSignedOut,
          );
        } else return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
    //return _handleCurrentScreen();
  }

}
