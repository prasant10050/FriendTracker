import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:friend_tracker/services/authentication.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class SignUp extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedUp;
  String userId;

  @override
  _SignUpState createState() => _SignUpState();

  SignUp({this.auth, this.onSignedUp,this.userId});
}

enum FormMode { LOGIN, SIGNUP }

class _SignUpState extends State<SignUp> {
  static final scaffoldKey = new GlobalKey<ScaffoldState>();
  static final formKey = new GlobalKey<FormState>();
  static String _firstName, _lastName, _phoneNUmber;

  FormMode _formMode = FormMode.LOGIN;
  bool _isIos;
  bool _isLoading;
  String _errorMessage;
  bool _permission = false;
  String error;
  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;
  StreamSubscription<Map<String, double>> _locationSubscription;
  GoogleMapController mapController;
  Marker marker;
  Location location=new Location();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  static var firstName = TextFormField(
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

  static bool isValidFirstName(String input) {
    if (input.trim().isEmpty) return false;
    return true;
  }

  static var lastName = TextFormField(
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

  static bool isValidLasName(String input) {
    if (input.trim().isEmpty) return false;
    return true;
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

  static bool isValidPhoneNumber(String input) {
    final RegExp regex = new RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
    return regex.hasMatch(input);
  }

  @override
  void initState(){
    super.initState();
    initPlatformState();
    /*_locationSubscription = location.onLocationChanged().listen((Map<String,double> value) async {
      setState(() {
        _currentLocation = value;
      })

    });*/
    
  }

  @override
  void dispose() {
    super.dispose();
    _locationSubscription.cancel();
  }

  initPlatformState() async {
    Map<String, double> _location;
    try {
      _permission = await location.hasPermission();
      _location = await location.getLocation();
      _locationSubscription=location.onLocationChanged().listen((Map<String,double> value) async{
        setState(() {
          _currentLocation=value;
        });
        if (marker != null) {
          mapController.removeMarker(marker);
        }
        marker = await mapController?.addMarker(MarkerOptions(
            position: LatLng(
              _currentLocation["latitude"],
              _currentLocation["longitude"],
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(240),),);
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
      });
      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }
      _location = null;
    }
    if (!mounted) return;
    setState(() {
      _startLocation = _location;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool _validateAndSave() {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        return true;
      }
      return false;
    }

    void showMessage(String message, [MaterialColor color = Colors.red]) {
      scaffoldKey.currentState.showSnackBar(
          new SnackBar(backgroundColor: color, content: new Text(message)));
    }

    _validateAndSubmit() async {
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });
      if (_validateAndSave()) {
        String userId = widget.userId;
        try {
          /*if (_formMode == FormMode.LOGIN) {
            userId = await widget.auth.signIn(_email, _password);
            print('Signed in: $userId');
          }
          if (_formMode == FormMode.SIGNUP) {
            userId = await widget.auth.signUp(_email, _password);
            print('Signed up user: $userId');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => new SignUp(
                      auth: widget.auth,
                    ),
              ),
            );
          }*/
          setState(() {
            _isLoading = false;
          });
          if (userId.length > 0 && userId != null) {
            //widget.onSignedIn();
          }
        } catch (e) {
          print('Error: $e');
          setState(() {
            _isLoading = false;
            if (_isIos) {
              _errorMessage = e.details;
            } else
              _errorMessage = e.message;
          });
        }
      }
    }

    Widget _showPrimaryButton() {
      return new Padding(
          padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
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

    var mapView = Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          height: MediaQuery.of(context).size.height*.5,
          width: MediaQuery.of(context).size.width*.5,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            options: GoogleMapOptions(
              cameraPosition: CameraPosition(
                  target: LatLng(_currentLocation["latitude"],
                      _currentLocation["longitude"]),
                  zoom: 20.0),
              mapType: MapType.normal,
            ),
          ),
        ),
      ],
    );

    var form = new Form(
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
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          form,
          Expanded(
            flex: 2,
            child:
                _currentLocation == null ? CircularProgressIndicator() : mapView,
          ),
        ],
      ),
    );
  }
}
