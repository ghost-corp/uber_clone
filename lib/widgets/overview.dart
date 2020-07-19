import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/api/location_math_api.dart';

class DistanceOverview extends StatefulWidget {
  final LatLng firstLocation;
  final InfoWindow firstLocationInfoWindow;
  final LatLng secondLocation;
  final InfoWindow secondLocationInfoWindow;
  final VoidCallback onPolylineDrawn;
  final AsyncValueGetter<List<Polyline>> getPolyline;
  final BitmapDescriptor firstLocationMarkerIcon;
  final BitmapDescriptor secondLocationMarkerIcon;

  DistanceOverview(
      {this.firstLocation,
      this.secondLocation,
      this.onPolylineDrawn,
      this.getPolyline,
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
  AsyncValueGetter<List<Polyline>> getPolyline;
  BitmapDescriptor firstLocationMarkerIcon;
  BitmapDescriptor secondLocationMarkerIcon;
  GoogleMapController mapController;
  InfoWindow firstLocationInfoWindow;
  InfoWindow secondLocationInfoWindow;
  bool polylineDrawn = false;
  Timer executionTimer;

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

    getPolyline = widget.getPolyline;

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
    return FutureBuilder(
      future: getPolyline.call(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Container();
        }

        if (snap.hasData) {
          polylineDrawn = true;
        }

        return GoogleMap(
          key: new GlobalKey(),
          onMapCreated: (controller) {
            mapController = controller;
            //delay is necessary to allow map to be completely built first before animating
            Timer(Duration(seconds: 1), () {
              focusMapOnBound(controller);
              if (snap.data.length > 0) {
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
          polylines: snap.data.length > 0 ? snap.data.toSet() : null,
          markers: snap.data.length > 0 ? Set<Marker>.of(markers) : null,
        );
      },
    );
  }
}
