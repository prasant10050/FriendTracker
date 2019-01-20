import 'package:flutter/material.dart';
import 'package:friend_tracker/Model/User.dart';
import 'package:friend_tracker/services/authentication.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TapUserMapView extends StatefulWidget {
  final User user;


  TapUserMapView({this.user});

  @override
  _TapUserMapViewState createState() => _TapUserMapViewState();
}

class _TapUserMapViewState extends State<TapUserMapView> {
  GoogleMapController mapController;
  Marker marker;
  String email;
  BaseAuth auth=new Auth();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.addMarker(MarkerOptions(
      position: LatLng(widget.user.location.latitude,
        widget.user.location.longitude,),
      icon: BitmapDescriptor.defaultMarker,
      visible: true,
      infoWindowText: InfoWindowText("${widget.user.name.firstName} ${widget.user.name.lastName}", "$email Last update time ${widget.user.datetime}")
    ));
    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            widget.user.location.latitude,
            widget.user.location.longitude,
          ),
          zoom: 20.0,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          email = user?.email;
        }
      });
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
                  target: LatLng(
                    widget.user.location.latitude,
                    widget.user.location.longitude,
                  ),
                  zoom: 20.0,
              ),
              mapType: MapType.normal,
            ),
          ),
        ),
      ],
    );

    Future<bool> onBackPressed() {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Do you want to back or exit this page"),
              actions: <Widget>[
                FlatButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            );
          });
    }

    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text("User Location"),
        ),
        body: (widget.user.location.latitude == null || widget.user.location.longitude == null)
            ? CircularProgressIndicator()
            : mapView,
        resizeToAvoidBottomPadding: false,
      ),
    );
  }
}
