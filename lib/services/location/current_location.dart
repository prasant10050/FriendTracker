import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';

class CurrentLocation {
  Position position;
  Geolocator geolocator;
  CurrentLocation() {
    geolocator = new Geolocator();
    //initPlatformState();
  }

  Future<Position> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      var geolocationStatus = await geolocator.checkGeolocationPermissionStatus();
      if(geolocationStatus==GeolocationStatus.granted){
        geolocator = Geolocator()
          ..forceAndroidLocationManager = true;
        position = await geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation);
        return position;
      }else{
        print("Permission not granted");
      }
    } on PlatformException {
      position = null;
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    /*if (!mounted) {
      return;
    }*/
    return position;
    /*setState(() {
      _position = position;
    });*/
  }

  Future<GeolocationStatus> geoLocationStatus() async{
    Geolocator geolocator = new Geolocator();
    var checkGeolocationPermissionStatus = await geolocator.checkGeolocationPermissionStatus();
    return checkGeolocationPermissionStatus;
    /*if(checkGeolocationPermissionStatus==GeolocationStatus.disabled)
      return message="Location services disabled,Enable location services for this App using the device settings.";
    else if(checkGeolocationPermissionStatus==GeolocationStatus.denied)
      return message ="Allow access to the location services for this App using the device settings.";
    else if(checkGeolocationPermissionStatus==GeolocationStatus.granted)
      return position;*/
  }
}
