import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  final Name name;
  final ULocation location;
  final String datetime;
  final String phone;

  User({this.name, this.phone, this.location,this.datetime});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      name: Name.fromJson(parsedJson['name']),
      datetime: parsedJson['datetime'],
      phone: parsedJson['phone'],
      location: ULocation.fromJson(parsedJson['location']),
    );
  }

  User.fromSnapshot(DataSnapshot snapshot)
      : key=snapshot.key,
        name = Name.fromSnapshot(snapshot),
        datetime=snapshot.value['datetime'],
        phone = snapshot.value['phone'],
        location = ULocation.fromSnapshot(snapshot);

  Map<String, dynamic> toJson() => {
        'name': name.toJson(),
        'phone': phone,
        'datetime':datetime,
        'location': location.toJSon(),
      };
}

class Name {
  final String firstName;
  final String lastName;

  Name({this.firstName, this.lastName});

  factory Name.fromJson(Map<String, dynamic> parsedJson) {
    return Name(
      firstName: parsedJson['firstname'],
      lastName: parsedJson['lastname'],
    );
  }

  Name.fromSnapshot(DataSnapshot snapshot)
      : firstName = snapshot.value['name']['firstname'],
        lastName = snapshot.value['name']['lastname'];

  Map<String, dynamic> toJson() => {
        'firstname': firstName,
        'lastname': lastName,
      };
}

class ULocation {
  final double latitude;
  final double longitude;

  ULocation({this.latitude, this.longitude});

  factory ULocation.fromJson(Map<String, dynamic> parsedJson) {
    return ULocation(
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
    );
  }

  ULocation.fromSnapshot(DataSnapshot snapshot)
      : latitude = snapshot.value['location']['latitude'],
        longitude = snapshot.value['location']['longitude'];

  Map<String, dynamic> toJSon() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}
