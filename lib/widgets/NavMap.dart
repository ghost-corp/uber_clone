import 'dart:async';
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/api/polyline_api.dart';
import 'package:uber_clone/models/location_model.dart';
import 'NavInfo.dart';

class NavMap extends StatefulWidget {
  @override
  State createState() => NavMapState();
}

class NavMapState extends State<NavMap> {
  StreamSubscription polyLineFetchStream;
  GoogleMapController mapController;
  bool fetchSuccess;

  @override
  void dispose() {
    if (polyLineFetchStream != null) {
      polyLineFetchStream.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationModel>(
      builder: (context, locationModel, _) {
        //markers for both pickup and dropoff locations
        List<Marker> markers = new List();
        Marker pickupMarker = new Marker(
            markerId: MarkerId("pickupMarker"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            infoWindow: InfoWindow(
                title: "Pickup Location",
                snippet:
                    "${locationModel.pickUpLocationInfo.formattedAddress}"),
            position: LatLng(locationModel.pickUpLocationInfo.latitude,
                locationModel.pickUpLocationInfo.longitude));

        Marker dropOffMarker = new Marker(
            markerId: MarkerId("drop"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            infoWindow: InfoWindow(
                title: "ETA: $timeOfArrival",
                snippet:
                    "${locationModel.dropOffLocationInfo.formattedAddress.length > 30 ? locationModel.dropOffLocationInfo.formattedAddress.substring(0, 27) + "..." : locationModel.dropOffLocationInfo.formattedAddress}"),
            position: LatLng(locationModel.dropOffLocationInfo.latitude,
                locationModel.dropOffLocationInfo.longitude));

        markers.add(pickupMarker);
        markers.add(dropOffMarker);

        // the focusMapOnBound method focuses the map on the overview polyline
        focusMapOnBound(GoogleMapController controller) async {
          int count = 0;
          LatLngBounds bounds = new LatLngBounds(
              southwest: calcSouthWestBound(
                  locationModel.steps[count].coords[0],
                  locationModel.steps[count]
                      .coords[locationModel.steps[count].coords.length - 1]),
              northeast: calcNorthEastBound(
                  locationModel.steps[count].coords[0],
                  locationModel.steps[count]
                      .coords[locationModel.steps[count].coords.length - 1]));
          print(bounds.toJson());
          CameraUpdate update = CameraUpdate.newLatLngBounds(bounds, 10);
          await controller.animateCamera(update);
          await controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: calcCenter(
                      locationModel.steps[count].coords[0].latitude,
                      locationModel.steps[count].coords[0].longitude,
                      locationModel
                          .steps[count]
                          .coords[locationModel.steps[count].coords.length - 1]
                          .latitude,
                      locationModel
                          .steps[count]
                          .coords[locationModel.steps[count].coords.length - 1]
                          .longitude),
                  zoom: calcZoom(locationModel.steps[count].distanceKm),
                  bearing: calcBearing(
                      locationModel.steps[count].coords[0].latitude,
                      locationModel.steps[count].coords[0].longitude,
                      locationModel
                          .steps[count]
                          .coords[locationModel.steps[count].coords.length - 1]
                          .latitude,
                      locationModel
                          .steps[count]
                          .coords[locationModel.steps[count].coords.length - 1]
                          .longitude))));
        }

        if (locationModel.overviewLines.length == 0) {
          //the polyLineFetchStream continuously tries to get the polyline in case of a network fetch error
          polyLineFetchStream = locationModel
              .getOverViewPolyLines()
              .asStream()
              .listen((event) async {
            while (locationModel.overviewLines.length == 0) {
              fetchSuccess = await locationModel.getOverViewPolyLines();
              Timer(Duration(seconds: 1), () {
                if (fetchSuccess) {
                  focusMapOnBound(mapController);
                }
              });
            }
            polyLineFetchStream.cancel();
          });
        }

        return Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
                //delay is necessary to allow map to be completely built first before animating
                Timer(Duration(seconds: 1), () {
                  focusMapOnBound(controller);
                  if (locationModel.overviewLines.length > 0) {
                    controller.showMarkerInfoWindow(MarkerId("drop"));
                  }
                });
              },
              initialCameraPosition: CameraPosition(
                  target: LatLng(locationModel.pickUpLocationInfo.latitude,
                      locationModel.pickUpLocationInfo.longitude),
                  zoom: 11.0),
              compassEnabled: false,
              trafficEnabled: false,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              rotateGesturesEnabled: true,
              mapToolbarEnabled: true,
              polylines: locationModel.navLines.length > 0
                  ? locationModel.navLines.toSet()
                  : null,
              markers: locationModel.navLines.length > 0
                  ? Set<Marker>.of(markers)
                  : null,
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: NavInfo(
                    currentStep: locationModel.steps[1],
                    futureStep: locationModel.steps[2],
                    nextStep: locationModel.steps[3],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () {
                    focusMapOnBound(mapController);
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.navigation,
                            size: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Center",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

LatLng calcCenter(lat1, lng1, lat2, lng2) {
  return LatLng((lat1 + lat2) / 2, (lng1 + lng2) / 2);
}

double calcZoom(double distance) {
  double zoom = 16 - Math.log(distance * 0.6) / Math.log(2);
  print("$zoom.................................");
  return zoom;
}

double calcBearing(lat1, lng1, lat2, lng2) {
  double dLon = (lng2 - lng1);
  double y = Math.sin(dLon) * Math.cos(lat2);
  double x = Math.cos(lat1) * Math.sin(lat2) -
      Math.sin(lat1) * Math.cos(lat2) * Math.cos(dLon);
  double brng = (Math.atan2(y, x)) * 180 / Math.pi;
  brng = (360 - ((brng + 360) % 360));
  return brng;
}
