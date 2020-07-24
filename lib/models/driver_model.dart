import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

class DriverModel {
  static List<Driver> getDummyDrivers(LatLng currentLocation) {
    return <Driver>[
      Driver(
          firstName: "Abdulmalik",
          lastName: "Abubakar",
          liveLocation: generateRandomLocation(currentLocation)),
      Driver(
          firstName: "Emmanuel",
          lastName: "Tuksa",
          liveLocation: generateRandomLocation(currentLocation)),
      Driver(
          firstName: "Eke",
          lastName: "Chimdi",
          liveLocation: generateRandomLocation(currentLocation)),
      Driver(
          firstName: "Eje",
          lastName: "Daniel",
          liveLocation: generateRandomLocation(currentLocation)),
      Driver(
          firstName: "Abdullahi",
          lastName: "Sani",
          liveLocation: generateRandomLocation(currentLocation)),
      Driver(
          firstName: "Muhammad",
          lastName: "Buhari",
          liveLocation: generateRandomLocation(currentLocation)),
      Driver(
          firstName: "Aminu",
          lastName: "Isa",
          liveLocation: generateRandomLocation(currentLocation)),
    ];
  }

  static LatLng generateRandomLocation(LatLng referenceLocation) {
    math.Random random = new math.Random();
    var u = random.nextDouble();
    var v = random.nextDouble();
    var w = (6000 / 111300) * math.sqrt(u);
    var t = 2 * math.pi * v;
    var x = w * math.cos(t);
    var y = w * math.sin(t);
    x = x / math.cos(referenceLocation.latitude);
    x = x + referenceLocation.longitude;
    y = y + referenceLocation.latitude;
    return LatLng(y, x);
  }
}

class Driver {
  String imageUrl;
  String licensePlate;
  String firstName;
  String lastName;
  String driverId;
  LatLng liveLocation;

  Driver(
      {this.lastName,
      this.firstName,
      this.imageUrl,
      this.driverId,
      this.licensePlate,
      this.liveLocation});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
        firstName: json['firstName'],
        lastName: json['lastName'],
        driverId: json['driverId'],
        liveLocation: LatLng(json['liveLocation'][0], json['liveLocation'][1]));
  }
}
