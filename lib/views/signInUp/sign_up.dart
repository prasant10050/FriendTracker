import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:friend_tracker/Model/User.dart';
import 'package:friend_tracker/services/authentication.dart';
import 'package:friend_tracker/services/currentDateTime.dart';
import 'package:friend_tracker/services/getLocation.dart';
import 'package:friend_tracker/services/location/current_location.dart';
import 'package:friend_tracker/util/loaders/color_loader_2.dart';
import 'package:friend_tracker/util/loaders/color_loader_3.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:friend_tracker/services/userManagement.dart';

class SignUp extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedUp;
  String userId;

  SignUp({this.auth, this.onSignedUp, this.userId});

  @override
  _SignUpState createState() => _SignUpState();
}

enum FormMode { LOGIN, SIGNUP }
enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _SignUpState extends State<SignUp> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  String _firstName, _lastName, _phoneNUmber, _dateTime, _errorMessage;
  Location location = new Location();
  bool _isIos;
  String error;
  GoogleMapController mapController;
  Marker marker;
  Position position;
  StreamSubscription<Position> _positionStreamSubscription;
  CurrentLocation currentLocation = new CurrentLocation();
  String geoLocationStatus;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    marker = mapController?.addMarker(
      MarkerOptions(
        position: LatLng(
          position.latitude,
          position.longitude,
        ),
        icon: BitmapDescriptor.defaultMarker,
        visible: true,
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

  @override
  void initState() {
    super.initState();
    _initPlatformState();
  }

  Future<void> _initPlatformState() async {
    //if (_positionStreamSubscription == null) {
    final LocationOptions locationOptions = LocationOptions(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
        forceAndroidLocationManager: true);
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
    //}
    if (!mounted) return;
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    showMessage(String message, [MaterialColor color = Colors.red]) {
      scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          backgroundColor: color,
          content: new Text(message),
        ),
      );
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

    bool _validateAndSave() {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        return true;
      }
      return false;
    }

    _validateAndSubmit() async {
      setState(() {
        _errorMessage = "";
      });
      if (_validateAndSave()) {
        String userId = "";
        try {
          Name name = new Name(firstName: _firstName, lastName: _lastName);

          ULocation ulocation = new ULocation(
              latitude: position.latitude, longitude: position.longitude);

          CurrentDateTime currentDateTime = new CurrentDateTime();
          _dateTime = currentDateTime.currentDateTime();
          User user = new User(
              name: name,
              phone: _phoneNUmber,
              location: ulocation,
              datetime: _dateTime);
          print(user);

          UserDatabase userDatabase = new UserDatabase();
          String status = await userDatabase.addNewUser(widget.userId, user);
          formKey.currentState.reset();
          print('Status: $status');
          showMessage("Registration Successful !!");
          if (status == "Success") {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return new GetLocation(
                userId: widget.userId,
                position: position,
              );
            }));
          }
        } catch (e) {
          print('Error: $e');
          setState(() {
            if (_isIos) {
              _errorMessage = e.details;
            } else
              _errorMessage = e.message;
          });
        }
      }
    }

    bool isValidFirstName(String input) {
      if (input.trim().isEmpty) return false;
      return true;
    }

    var firstName = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: "Enter first name",
        labelText: "First Name",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      inputFormatters: [new LengthLimitingTextInputFormatter(15)],
      validator: (input) =>
          isValidFirstName(input) ? null : "First name is required",
      onSaved: (input) => _firstName = input,
    );

    bool isValidLasName(String input) {
      if (input.trim().isEmpty) return false;
      return true;
    }

    var lastName = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: "Enter last name",
        labelText: "Last Name",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      inputFormatters: [new LengthLimitingTextInputFormatter(15)],
      validator: (input) =>
          isValidLasName(input) ? null : "Last name is required",
      onSaved: (input) => _lastName = input,
    );

    bool isValidPhoneNumber(String input) {
      final RegExp regex = new RegExp(r'^\d\d\d\d\d\d\d\d\d\d$');
      //r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$'
      return regex.hasMatch(input);
    }

    var phoneNumber = TextFormField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: "Enter mobile number",
        labelText: "Mobile Number",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      inputFormatters: [
        new WhitelistingTextInputFormatter(new RegExp(r'^[()\d -]{1,15}$')),
      ],
      validator: (input) => isValidPhoneNumber(input)
          ? null
          : "Phone number must be entered as (###)###-####",
      onSaved: (input) => _phoneNUmber = input,
    );

    Widget _showPrimaryButton() {
      return new Padding(
          padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
          child: SizedBox(
            height: 40.0,
            child: new RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              color: Colors.blue,
              child: new Text('Submit',
                  style: new TextStyle(fontSize: 20.0, color: Colors.white)),
              onPressed: _validateAndSubmit,
            ),
          ));
    }

    var logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset(
          'assets/location4.jpg',
          height: MediaQuery.of(context).size.height * .5,
          width: MediaQuery.of(context).size.width * .5,
        ),
      ),
    );

    _map() {
      return FutureBuilder<GeolocationStatus>(
        future: Geolocator().checkGeolocationPermissionStatus(),
        builder:
            (BuildContext context, AsyncSnapshot<GeolocationStatus> snapshot) {
          if (snapshot.data == GeolocationStatus.disabled) {
            return showMessage(
                'Location services disabled, Enable location services for this App using the device settings.');
          }

          if (snapshot.data == GeolocationStatus.denied) {
            return showMessage(
                'Access to location denied, Allow access to the location services for this App using the device settings.');
          }
          if (snapshot.data == GeolocationStatus.granted) {
            return Container(
              height: MediaQuery.of(context).size.height * .5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                //border: Border.all(width: 3.0),
                borderRadius: BorderRadius.circular(4.0),
              ),
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
            );
          }
          return Container(
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              //border: Border.all(width: 3.0),
              borderRadius: BorderRadius.circular(4.0),
            ),
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
          );
        },
      );
    }

    var form = Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            logo,
            SizedBox(
              height: 10.0,
            ),
            firstName,
            SizedBox(
              height: 10.0,
            ),
            lastName,
            SizedBox(
              height: 10.0,
            ),
            phoneNumber,
            SizedBox(
              height: 10.0,
            ),
            _showPrimaryButton(),
            SizedBox(
              height: 10.0,
            ),
            position == null ? _buildCircularIndicator() : _map(),
          ],
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Stack(
        children: <Widget>[
          position == null ? _buildCircularIndicator() : form,
        ],
      ),
    );
  }
}
