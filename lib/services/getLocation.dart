import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friend_tracker/services/authentication.dart';
import 'package:friend_tracker/services/bloc/LocationBlocProvider.dart';
import 'package:friend_tracker/services/currentDateTime.dart';
import 'package:friend_tracker/services/userManagement.dart';
import 'package:friend_tracker/util/loaders/color_loader_2.dart';
import 'package:friend_tracker/views/home.dart';
import 'package:friend_tracker/views/map/map.dart';
import 'package:friend_tracker/views/showAllUsers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GetLocation extends StatefulWidget {
  final String userId;
  BaseAuth auth;
  VoidCallback onSignedOut;

  GetLocation({this.userId, this.auth, this.onSignedOut});

  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  /*Location _location =new Location();
  bool _permission = false;*/
  String error;

  /* Map<String, double> _startLocation;
  Map<String, double> _currentLocation;

  //StreamSubscription<Map<String, double>> _locationSubscription;*/
  GoogleMapController mapController;
  Marker marker;

  //Location location;
  var userLocation = {};
  CurrentDateTime startDateTime = new CurrentDateTime();
  String currentDateTime;
  UserDatabase userDatabase = new UserDatabase();

  //Getlocator
  StreamSubscription<Position> _positionStreamSubscription;
  final List<Position> _positions = <Position>[];
  Position position;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  //OnMapCreated
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    marker = mapController?.addMarker(MarkerOptions(
      position: LatLng(
        position.latitude,
        position.longitude,
      ),
      icon: BitmapDescriptor.defaultMarker,
    ),
    ) as Marker;
    mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            position.latitude,
            position.longitude,
          ),
          zoom: 20.0,
        ),
      ),
    );
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription.isPaused);

  @override
  void initState() {
    /*_location = new Location();*/

    super.initState();
    //initPlatformState();
    /*_locationSubscription=_location.onLocationChanged().listen((Map<String, double> result) async {
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
    });*/
    if (_positionStreamSubscription == null) {
      const LocationOptions locationOptions =
          LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 10);
      final Stream<Position> positionStream =
          Geolocator().getPositionStream(locationOptions);
      _positionStreamSubscription =
          positionStream.listen((Position _position) async {
        setState(() {
          position = _position;
        });
        if (marker != null) {
          mapController.removeMarker(marker);
        }
        marker = await mapController?.addMarker(
          MarkerOptions(
            position: LatLng(
              position.latitude,
              position.longitude,
            ),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
        await mapController?.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                position.latitude,
                position.longitude,
              ),
              zoom: 20.0,
            ),
          ),
        );
      });
      //_positionStreamSubscription.pause();
      //_positionStreamSubscription.resume();
    }

    /*setState(() {
      if (_positionStreamSubscription.isPaused) {
        _positionStreamSubscription.resume();
      } else {
        _positionStreamSubscription.pause();
      }
    });*/
    if (!mounted) return;
  }

  @override
  void dispose() {
    //_locationSubscription.cancel();
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }

    super.dispose();
  }

  /*initPlatformState() async {
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
  }*/
  showMessage(String message, [MaterialColor color = Colors.red]) {
    scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  _buildCircularIndicator() {
    return Center(
      child: ColorLoader2(
        color1: Colors.redAccent,
        color2: Colors.green,
        color3: Colors.amber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    var mapView = FutureBuilder<GeolocationStatus>(
        future: Geolocator().checkGeolocationPermissionStatus(),
        builder:
            (BuildContext context, AsyncSnapshot<GeolocationStatus> snapshot) {
          if (!snapshot.hasData) {
            return _buildCircularIndicator();
            print("No DATA");
          }

          if (snapshot.data == GeolocationStatus.denied) {
            return showMessage(
                'Location services disabled, Enable location services for this App using the device settings.');
          }
          if (snapshot.data == GeolocationStatus.granted) {
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  //height: MediaQuery.of(context).size.height,
                  //width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    options: GoogleMapOptions(
                      cameraPosition: CameraPosition(
                          target: LatLng(
                            position.latitude,
                            position.longitude,
                          ),
                          zoom: 20.0),
                      mapType: MapType.normal,
                    ),
                  ),
                ),
              ],
            );
          }
        });

    _signOut() async {
      try {
        if (widget.auth == null || widget.userId == null) {
          HomePage homePage = new HomePage();
          homePage.auth.signOut();
          //homePage.createState().authStatus=AuthStatus.NOT_LOGGED_IN;
          homePage.createState().onSignedOut();
        }
        await widget.auth.signOut();
        widget.onSignedOut();
        //_locationSubscription.cancel();
        //last location
        CurrentDateTime currentDateTime = new CurrentDateTime();
        userLocation['latitude'] = position.latitude;
        userLocation['longitude'] = position.longitude;
        String status = await userDatabase.updateUserLocation(
            widget.userId, userLocation, currentDateTime.currentDateTime());
        print("Sign out , location update $status");
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      key: scaffoldKey,
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
            icon: Icon(
              FontAwesomeIcons.users,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => new ShowAllUsers(),
                ),
              );
            },
            tooltip: "Show All Users",
          ),
        ],
      ),
      body: Container(
        child: position == null ? _buildCircularIndicator() : mapView,
      ),
    );
  }
}
