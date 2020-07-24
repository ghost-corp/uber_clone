import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/models/auth_model.dart';

class TripModel extends ChangeNotifier {
  StreamSubscription currentTripStream;
  Trip currentTrip;
  bool connectToDriver = false;

  TripModel() {
    currentTripStream = Firestore.instance
        .collection('users')
        .document(globalUser.uid)
        .collection('currentTrip')
        .document('tripDetails')
        .snapshots()
        .listen((tripSnapshot) {
      if (tripSnapshot.data == null) {
        currentTrip = null;
      } else {
        connectToDriver = false;
        currentTrip = Trip.fromJson(tripSnapshot.data);
      }
      notifyListeners();
    });
  }

  void cancelSubs() {
    currentTripStream.cancel();
  }

  void setConnectingToDriver(bool value) {
    connectToDriver = value;
    notifyListeners();
  }
}

class Trip {
  String driverName;
  String driverPhone;
  String driverId;
  LatLng destinationCoords;
  LatLng pickupCoords;

  Trip(
      {this.driverId,
      this.driverName,
      this.driverPhone,
      this.destinationCoords,
      this.pickupCoords});

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      driverName: json['driverName'],
      driverPhone: json['driverPhone'],
      driverId: json['driverId'],
      destinationCoords:
          LatLng(json['destinationCoords'][0], json['destinationCoords'][1]),
      pickupCoords: LatLng(json['pickupCoords'][0], json['pickupCoords'][1]),
    );
  }
}
