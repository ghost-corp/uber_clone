import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/api/location_math_api.dart';
import 'package:uber_clone/api/polyline_api.dart';

class DistanceOverview extends StatefulWidget {
  final LatLng firstLocation;
  final InfoWindow firstLocationInfoWindow;
  final LatLng secondLocation;
  final InfoWindow secondLocationInfoWindow;
  final VoidCallback onPolylineDrawn;
  final BitmapDescriptor firstLocationMarkerIcon;
  final BitmapDescriptor secondLocationMarkerIcon;

  DistanceOverview(
      {this.firstLocation,
      this.secondLocation,
      this.onPolylineDrawn,
      this.firstLocationInfoWindow,
      this.secondLocationInfoWindow,
      this.firstLocationMarkerIcon,
      this.secondLocationMarkerIcon});
  @override
  State createState() => DistanceOverviewState();
}

class DistanceOverviewState extends State<DistanceOverview> {
  LatLng firstLocation;
  LatLng secondLocation;
  VoidCallback onPolylineDrawn;
  List<Marker> markers = new List();
  List<Polyline> polyLine;
  BitmapDescriptor firstLocationMarkerIcon;
  BitmapDescriptor secondLocationMarkerIcon;
  GoogleMapController mapController;
  InfoWindow firstLocationInfoWindow;
  InfoWindow secondLocationInfoWindow;
  StreamSubscription getPolylineStream;
  bool polylineDrawn = false;
  Timer executionTimer;

  Future<List<Polyline>> getPolyline() async {
    Map result = await PolylineApi.getPolyLines(firstLocation, secondLocation);
    if (result == null) {
      return null;
    }
    List<LatLng> coords = result['polyline'];
    List<Polyline> line = [
      Polyline(
          polylineId: PolylineId("driver distance"), width: 3, points: coords)
    ];
    return line;
  }

  @override
  void dispose() {
    getPolylineStream.cancel();
    super.dispose();
  }

  @override
  void initState() {
    firstLocation = widget.firstLocation;
    secondLocation = widget.secondLocation;
    firstLocationInfoWindow = widget.firstLocationInfoWindow;
    secondLocationInfoWindow = widget.secondLocationInfoWindow;
    onPolylineDrawn = widget.onPolylineDrawn;
    firstLocationMarkerIcon = widget.firstLocationMarkerIcon;
    secondLocationMarkerIcon = widget.secondLocationMarkerIcon;
    executionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (polylineDrawn == true) {
        try {
          onPolylineDrawn();
          timer.cancel();
        } catch (err) {}
      }
    });
    getPolylineStream = getPolyline().asStream().listen((poly) async {
      if (poly == null) {
        while (polyLine == null) {
          poly = await getPolyline();
          if (poly != null) {
            setState(() {
              polyLine = poly;
            });
          }
        }
      }
      setState(() {
        polyLine = poly;
      });
    });

    Marker pickupMarker = new Marker(
        markerId: MarkerId("pickupMarker"),
        icon: firstLocationMarkerIcon != null
            ? firstLocationMarkerIcon
            : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow:
            firstLocationInfoWindow != null ? firstLocationInfoWindow : null,
        position: LatLng(firstLocation.latitude, firstLocation.longitude));

    Marker dropOffMarker = new Marker(
        markerId: MarkerId("drop"),
        icon: secondLocationMarkerIcon != null
            ? secondLocationMarkerIcon
            : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow:
            secondLocationInfoWindow != null ? secondLocationInfoWindow : null,
        position: LatLng(secondLocation.latitude, secondLocation.longitude));

    markers.add(pickupMarker);
    markers.add(dropOffMarker);
    super.initState();
  }

  void focusMapOnBound(GoogleMapController controller) {
    LatLngBounds bounds = new LatLngBounds(
        southwest:
            LocationMathApi.calcSouthWestBound(firstLocation, secondLocation),
        northeast:
            LocationMathApi.calcNorthEastBound(firstLocation, secondLocation));
    CameraUpdate update = CameraUpdate.newLatLngBounds(bounds, 100);
    controller.animateCamera(update);
    try {
      controller.showMarkerInfoWindow(MarkerId("drop"));
    } catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    if (polyLine == null) {
      return Container();
    }

    polylineDrawn = true;

    return GoogleMap(
      key: new GlobalKey(),
      onMapCreated: (controller) {
        mapController = controller;
        //delay is necessary to allow map to be completely built first before animating
        Timer(Duration(seconds: 1), () {
          focusMapOnBound(controller);
          if (polyLine.length > 0) {
            controller.showMarkerInfoWindow(MarkerId("drop"));
          }
        });
      },
      initialCameraPosition: CameraPosition(
          target: LatLng(firstLocation.latitude, firstLocation.longitude),
          zoom: 11.0),
      compassEnabled: false,
      trafficEnabled: false,
      myLocationEnabled: false,
      zoomControlsEnabled: false,
      rotateGesturesEnabled: false,
      mapToolbarEnabled: true,
      polylines: polyLine.length > 0 ? polyLine.toSet() : null,
      markers: polyLine.length > 0 ? Set<Marker>.of(markers) : null,
    );
  }
}
