import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friend_tracker/services/authentication.dart';
import 'package:friend_tracker/views/map/map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
class GetLocation extends StatefulWidget {
  final String userId;
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  GetLocation({this.userId, this.auth, this.onSignedOut});

  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  var _location=new Location();
  bool _permission = false;
  String error;
  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;
  StreamSubscription<Map<String, double>> _locationSubscription;
  GoogleMapController mapController;
  Marker marker;
  Location location;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
    _locationSubscription =
        _location.onLocationChanged().listen((Map<String,double> result) async{
          setState(() {
            _currentLocation = result;
          });

            if(marker != null) {
              mapController.removeMarker(marker);
            }
            marker = await mapController?.addMarker(
                  MarkerOptions(
                      position: LatLng(
                        _currentLocation["latitude"],
                        _currentLocation["longitude"],
                      ),
                      icon: BitmapDescriptor.defaultMarker
                  )
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



        });
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
        error = 'Permission denied - please ask the user to enable it from the app settings';
      }
      location = null;
    }

    setState(() {
      _startLocation = location;
    });

  }

  @override
  Widget build(BuildContext context) {

    var mapView=Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            options: GoogleMapOptions(
              cameraPosition: CameraPosition(
                  target: LatLng(_currentLocation["latitude"], _currentLocation["longitude"]),
                  zoom: 20.0
              ),
              mapType: MapType.normal,
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      body: Center(
        child: Container(
          child: _startLocation==null?CircularProgressIndicator():mapView,
        ),
      ),
    );
  }
}
