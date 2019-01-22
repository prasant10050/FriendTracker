import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friend_tracker/services/authentication.dart';
import 'package:friend_tracker/services/bloc/LocationBlocProvider.dart';
import 'package:friend_tracker/services/currentDateTime.dart';
import 'package:friend_tracker/services/userManagement.dart';
import 'package:friend_tracker/views/home.dart';
import 'package:friend_tracker/views/map/map.dart';
import 'package:friend_tracker/views/showAllUsers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GetLocation extends StatefulWidget {
  String userId;
  BaseAuth auth;
  VoidCallback onSignedOut;

  GetLocation({this.userId, this.auth, this.onSignedOut});

  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  Location _location =new Location();
  bool _permission = false;
  String error;
  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;
  StreamSubscription<Map<String, double>> _locationSubscription;
  GoogleMapController mapController;
  Marker marker;
  //Location location;
  var userLocation = {};
  CurrentDateTime startDateTime=new CurrentDateTime();
  String currentDateTime;
  UserDatabase userDatabase = new UserDatabase();

  //Getlocator
  StreamSubscription<Position> _positionStreamSubscription;
  final List<Position> _positions = <Position>[];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    /*_location = new Location();*/

    super.initState();
    initPlatformState();
    _locationSubscription=_location.onLocationChanged().listen((Map<String, double> result) async {
      setState(() {
        _currentLocation = result;
      });
      currentDateTime=startDateTime.currentDateTime();
      userLocation['latitude'] = _currentLocation['latitude'];
      userLocation['longitude'] = _currentLocation['longitude'];

      if (marker != null) {
        mapController.removeMarker(marker);
      }
      marker = await mapController?.addMarker(MarkerOptions(
          position: LatLng(
            _currentLocation["latitude"],
            _currentLocation["longitude"],
          ),
          icon: BitmapDescriptor.defaultMarker,
      ),
      );
      mapController?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              _currentLocation["latitude"],
              _currentLocation["longitude"],
            ),
            zoom: 20.0,
          ),
        ),
      );

      String status=await userDatabase.updateUserLocation(widget.userId, userLocation,currentDateTime);
      print("InitiState, location update $status");
      print("$status $userLocation");
    });
    if(!mounted)
      return;

  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }

  initPlatformState() async {
    Map<String, double> location;
    try {
      _permission = await _location.hasPermission();
      location = await _location.getLocation();
      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }
      location = null;
    }
    if (!mounted) return;
    setState(() {
      _startLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mapView = Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          //height: MediaQuery.of(context).size.height,
          //width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            options: GoogleMapOptions(
              cameraPosition: CameraPosition(
                  target: LatLng(_currentLocation["latitude"], _currentLocation["longitude"],),
                  zoom: 20.0),
              mapType: MapType.normal,
            ),
          ),
        ),
      ],
    );

    _signOut() async {
      try {
        if(widget.auth==null || widget.userId==null){
          HomePage homePage=new HomePage();
          homePage.auth.signOut();
          //homePage.createState().authStatus=AuthStatus.NOT_LOGGED_IN;
          homePage.createState().onSignedOut();
        }
        await widget.auth.signOut();
        widget.onSignedOut();
        //_locationSubscription.cancel();
        //last location
        CurrentDateTime currentDateTime=new CurrentDateTime();
        userLocation['latitude'] = _currentLocation['latitude'];
        userLocation['longitude'] = _currentLocation['longitude'];
        String status=await userDatabase.updateUserLocation(widget.userId, userLocation,currentDateTime.currentDateTime());
        print("Sign out , location update $status");
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.power_settings_new,
                size: 30.0,
              ),
              tooltip: "Logout",
              onPressed: _signOut),
          new IconButton(
              icon: Icon(FontAwesomeIcons.users,size: 30.0,),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>new ShowAllUsers(),),);
              },
            tooltip: "Show All Users",
          ),
        ],
      ),
      body: Container(
        child: _currentLocation == null ? CircularProgressIndicator() : mapView,
      ),
    );
  }
}



