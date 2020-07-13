import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uber_clone/api/search_api.dart';
import 'package:uber_clone/models/driver_model.dart';

class LocationModel extends ChangeNotifier {
  Location location = new Location();
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData currentLocation;
  Place pickUpLocationInfo =
      new Place(formattedAddress: "", placeId: "", name: "");
  Place dropOffLocationInfo =
      new Place(formattedAddress: "", placeId: "", name: "");
  GoogleMapController
      mapController; //FIXME What is the use of this controller??
  List<Driver> nearbyDrivers = new List();
  Timer timer;

  LocationModel() {
    setLocation();
  }

  void setLocation() async {
    //checks if location service is enabled and Enable service if disabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    //checks if location permission is granted and requests permission if not granted.
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    //get current user location
    currentLocation = await location.getLocation();
    pickUpLocationInfo = await SearchApi.convertCoordinatesToAddress(
        LatLng(currentLocation.latitude, currentLocation.longitude));
    nearbyDrivers = DriverModel.getDummyDrivers(
        LatLng(currentLocation.latitude, currentLocation.longitude));
    notifyListeners();

    //update user location as it changes
    timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      print("updating location");
      currentLocation = await location.getLocation();
      pickUpLocationInfo = await SearchApi.convertCoordinatesToAddress(
          LatLng(currentLocation.latitude, currentLocation.longitude));
      notifyListeners();
    });
  }
}
