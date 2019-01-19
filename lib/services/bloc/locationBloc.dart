import 'dart:async';
import 'package:location/location.dart';

class LocationBloc{
  final Location location=new Location();
  Map<String, double> currentLocation;
  StreamController<Map<String, double>> locationController=new StreamController<Map<String, double>>();
  StreamSink<Map<String, double>> get inLocation=>locationController.sink;
  Stream<Map<String, double>> get outLocation=>locationController.stream;

  LocationBloc(){
    _getLocation().then((value){
      currentLocation=value;
      inLocation.add(value);
    });
    locationController.stream.listen(handleLocation);
    location.onLocationChanged().listen((value){
      handleLocation(value);
    });
  }
  Future<Map<String, double>> _getLocation() async {
    var currentLocation = <String, double>{};
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
  

  void handleLocation(Map<String, double> event) {
    //locationList.add(event);
    inLocation.add(event);
  }
}
