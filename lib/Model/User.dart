class User {
  Name name;
  ULocation location;
  String phone;

  User({this.name, this.phone, this.location});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      name: Name.fromJson(parsedJson['name']),
      phone: parsedJson['phone'],
      location: ULocation.fromJson(parsedJson['location']),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'location': location,
      };
}

class Name {
  String firstName;
  String lastName;

  Name({this.firstName, this.lastName});

  factory Name.fromJson(Map<String, dynamic> parsedJson) {
    return Name(
      firstName: parsedJson['firstname'],
      lastName: parsedJson['lastname'],
    );
  }

  Map<String, dynamic> toJson() => {
        'firstname': firstName,
        'lastname': lastName,
      };
}

class ULocation {
  double latitude;
  double longitude;

  ULocation({this.latitude, this.longitude});

  factory ULocation.fromJson(Map<String, dynamic> parsedJson) {
    return ULocation(
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
    );
  }

  Map<String, dynamic> toJSon() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}
