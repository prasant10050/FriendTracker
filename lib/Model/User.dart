import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  final Name name;
  final ULocation location;
  final String phone;

  User({this.name, this.phone, this.location});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      name: Name.fromJson(parsedJson['name']),
      phone: parsedJson['phone'],
      location: ULocation.fromJson(parsedJson['location']),
    );
  }

  User.fromSnapshot(DataSnapshot snapshot)
      : name = Name.fromSnapshot(snapshot.value['name']),
        phone = snapshot.value['phone'],
        location = ULocation.fromSnapshot(snapshot.value['location']);

  Map<String, dynamic> toJson() => {
        'name': name.toJson(),
        'phone': phone,
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
      : firstName = snapshot.value['firstname'],
        lastName = snapshot.value['lastname'];

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
      : latitude = snapshot.value['snapshot'],
        longitude = snapshot.value['longitude'];

  Map<String, dynamic> toJSon() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}
