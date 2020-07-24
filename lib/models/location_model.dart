import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_polyutil/google_map_polyutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uber_clone/api/location_math_api.dart';
import 'package:uber_clone/api/polyline_api.dart';
import 'package:uber_clone/api/search_api.dart';
import 'package:uber_clone/models/driver_model.dart';
import 'package:polyline/polyline.dart' as poly;
import 'package:uber_clone/models/auth_model.dart';

class LocationModel extends ChangeNotifier {
  //location attributes
  Location location = new Location();
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData currentLocation;
  Place currentLocationInfo = new Place();
  Place pickUpLocationInfo = new Place();
  Place dropOffLocationInfo = new Place();
  Timer timer;

  //navigation variables
  List<Polyline> overviewLines = new List();
  List<Polyline> navLines = new List();
  List<LatLng> navCoords = new List();
  List<Step> steps = new List();
  List<Step> nextThreeSteps = new List();

  //map mode
  MapMode mapMode = MapMode.NearestDriver;

  //nearbyDrivers
  List<Driver> nearbyDrivers = new List();
  StreamSubscription nearbyDriversStream;

  //ride
//  StreamSubscription ride

  LocationModel() {
    setLocation();
    nearbyDriversStream = Firestore.instance
        .collection('drivers')
        .where("isOnline", isEqualTo: true)
        .snapshots()
        .listen((driversSnapshot) {
      nearbyDrivers = new List();
      driversSnapshot.documents.forEach((driverSnap) {
        nearbyDrivers.add(Driver.fromJson(driverSnap.data));
      });
      notifyListeners();
    });
  }

  void cancelSubs() {
    nearbyDriversStream.cancel();
  }

  void setMapMode(MapMode mode) async {
    mapMode = mode;
    if (mode == MapMode.DestinationNavigation) {
      timer.cancel();
      nearbyDriversStream.cancel();
      timer = Timer.periodic(Duration(seconds: 4), (timer) async {
        currentLocation = await location.getLocation();
        bool onPath = false;
        bool onEdge = false;
        for (int x = 0; x < steps.length; x++) {
          onPath = await GoogleMapPolyUtil.isLocationOnPath(
              point:
                  LatLng(currentLocation.latitude, currentLocation.longitude),
              polygon: steps[x].coords,
              geodesic: true,
              tolerance: 12);
          notifyListeners();
          onEdge = await GoogleMapPolyUtil.isLocationOnEdge(
              point:
                  LatLng(currentLocation.latitude, currentLocation.longitude),
              polygon: steps[x].coords,
              geodesic: true,
              tolerance: 12);
          if (onPath == true && onEdge == true) {
            nextThreeSteps = new List();
            print("User on track");
            for (int y = x; y < x + 3; y++) {
              if (y < steps.length) {
                try {
                  print(steps[y].maneuver);
                } catch (err) {}
                nextThreeSteps.add(steps[y]);
              }
            }
            notifyListeners();
            break;
          }
        }
        if (onEdge == false && onEdge == false) {
          print("re-routing");
          getOverViewPolyLines(useCurrentLocation: true);
        }
        notifyListeners();
      });
    } else if (mode == MapMode.NearestDriver) {
      await location.changeSettings(accuracy: LocationAccuracy.navigation);
      timer.cancel();
      timer = Timer.periodic(Duration(seconds: 20), (timer) async {
        currentLocation = await location.getLocation();
        currentLocationInfo = await SearchApi.convertCoordinatesToAddress(
            LatLng(currentLocation.latitude, currentLocation.longitude));
        notifyListeners();
      });
      nearbyDriversStream = Firestore.instance
          .collection('drivers')
          .where("isOnline", isEqualTo: true)
          .snapshots()
          .listen((driversSnapshot) {
        driversSnapshot.documents.forEach((driverSnap) {
          nearbyDrivers.add(Driver.fromJson(driverSnap.data));
        });
        notifyListeners();
      });
    } else if (mode == MapMode.AwaitingDriver) {
      timer.cancel();
      nearbyDriversStream.cancel();
    }
    notifyListeners();
  }

  Driver getNearestDriver() {
    if (nearbyDrivers.length == 0) {
      return null;
    }
    Driver nearestDriver = nearbyDrivers[0];
    double dist = 0;
    for (int x = 0; x < nearbyDrivers.length; x++) {
      double distance = LocationMathApi.getDistanceFromLatLonInKm(
          nearbyDrivers[x].liveLocation.latitude,
          nearbyDrivers[x].liveLocation.longitude,
          pickUpLocationInfo.latitude,
          pickUpLocationInfo.longitude);
      if (distance < dist) {
        nearestDriver = nearbyDrivers[x];
        dist = distance;
      }
    }
    return nearestDriver;
  }

  void setPickupLocationInfo(Place location) {
    pickUpLocationInfo = location;
    notifyListeners();
  }

  void setDropOffLocationInfo(Place location) {
    dropOffLocationInfo = location;
    notifyListeners();
  }

  void resetOverviewLine() {
    overviewLines = new List();
    notifyListeners();
  }

  Future<List<Polyline>> getOverViewPolyLines(
      {bool useCurrentLocation = false}) async {
    var result = await PolylineApi.getPolyLines(
        useCurrentLocation
            ? LatLng(currentLocation.latitude, currentLocation.longitude)
            : LatLng(pickUpLocationInfo.latitude, pickUpLocationInfo.longitude),
        LatLng(dropOffLocationInfo.latitude, dropOffLocationInfo.longitude));
    if (result == null) {
      return null;
    }
    List<LatLng> coordinates = result['polyline'];
    if (coordinates != null) {
      Polyline line = Polyline(
          polylineId: PolylineId("trip_overview"),
          points: coordinates,
          width: 3);
      Polyline navLine = Polyline(
          polylineId: PolylineId("trip_overview"),
          points: coordinates,
          color: Colors.lightBlueAccent,
          width: 15);
      overviewLines = new List();
      overviewLines.add(line);

      navLines = new List();
      navLines.add(navLine);

      navCoords = new List();
      navCoords = coordinates;

      steps = result['steps'];
      nextThreeSteps = new List();
      try {
        nextThreeSteps.add(steps[0]);
        nextThreeSteps.add(steps[1]);
        nextThreeSteps.add(steps[2]);
      } catch (err) {
        print(err);
      }
      notifyListeners();
      return overviewLines;
    } else {
      return null;
    }
  }

  void setLocation() async {
    //checks if location service is enabled and Enable service if disabled
    await location.changeSettings(accuracy: LocationAccuracy.navigation);
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
    currentLocationInfo = await SearchApi.convertCoordinatesToAddress(
        LatLng(currentLocation.latitude, currentLocation.longitude));
//    nearbyDrivers = DriverModel.getDummyDrivers(
//        LatLng(currentLocation.latitude, currentLocation.longitude));
    notifyListeners();

    //update user location as it changes
    timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      print("updating location");
      currentLocation = await location.getLocation();
      currentLocationInfo = await SearchApi.convertCoordinatesToAddress(
          LatLng(currentLocation.latitude, currentLocation.longitude));
      notifyListeners();
    });
  }

  void sendRideRequests() async {
    nearbyDrivers.forEach((driver) {
      Firestore.instance
          .collection('drivers')
          .document(driver.driverId)
          .collection('tripRequests')
          .add({
        "riderId": globalUser.uid,
        "riderName": globalUserDetails.firstName,
        "riderPhone": globalUserDetails.phoneNumber,
        "riderDestinationCoords": [
          dropOffLocationInfo.latitude,
          dropOffLocationInfo.longitude
        ],
        "riderPickupCoords": [
          pickUpLocationInfo.latitude,
          pickUpLocationInfo.longitude
        ]
      });
    });
  }
}

enum MapMode { NearestDriver, DestinationNavigation, AwaitingDriver }

class Step {
  String distance;
  String duration;
  LatLng startLocation;
  LatLng endLocation;
  String maneuver;
  Polyline polyLine;
  List<LatLng> coords;
  double distanceKm;

  Step(
      {this.distance,
      this.coords,
      this.duration,
      this.endLocation,
      this.distanceKm,
      this.maneuver,
      this.polyLine,
      this.startLocation});

  factory Step.fromJson(Map<String, dynamic> json) {
    List<LatLng> coordinates = PolylineApi.coordinatesConverter(
        poly.Polyline.Decode(
            precision: 5, encodedString: json['polyline']['points']));
    Polyline line = Polyline(
        polylineId: PolylineId("trip_overview"), points: coordinates, width: 3);
    return Step(
        distance: json['distance']['text'],
        coords: coordinates,
        duration: json['duration']['text'],
        startLocation: LatLng(
            json['start_location']['lat'], json['start_location']['lng']),
        endLocation:
            LatLng(json['end_location']['lat'], json['end_location']['lng']),
        polyLine: line,
        distanceKm: LocationMathApi.getDistanceFromLatLonInKm(
            json['start_location']['lat'],
            json['start_location']['lng'],
            json['end_location']['lat'],
            json['end_location']['lng']),
        maneuver: json['maneuver']);
  }
}
