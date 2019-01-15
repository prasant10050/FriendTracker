import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapView extends StatefulWidget {
  //double latitute,longitude;
  Location location;

  MapView(this.location);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController mapController;
  Marker marker;
  Location location;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  //double latitude,longitude;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      //latitude=widget.latitute;
      //longitude=widget.longitude;
      location=widget.location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            options: GoogleMapOptions(
              cameraPosition: CameraPosition(
                target: LatLng(null, null),
                zoom: 14.0
              ),
              mapType: MapType.normal,

            ),
          ),
        ),
      ],
    );
  }
}
