import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/api/polyline_api.dart';
import 'package:uber_clone/global/screen_size.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/models/location_model.dart';

class ConfirmPickUpScreen extends StatefulWidget {
  @override
  _ConfirmPickUpScreenState createState() => _ConfirmPickUpScreenState();
}

class _ConfirmPickUpScreenState extends State<ConfirmPickUpScreen> {
  GlobalKey mapKey = new GlobalKey();
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

  LatLng calcNorthEastBound(LatLng pos1, LatLng pos2) {
    double lat;
    double lng;
    if (pos1.latitude > pos2.latitude) {
      lat = pos1.latitude;
    } else {
      lat = pos2.latitude;
    }

    if (pos1.longitude > pos2.longitude) {
      lng = pos1.longitude;
    } else {
      lng = pos2.longitude;
    }
    return LatLng(lat, lng);
  }

  LatLng calcSouthWestBound(LatLng pos1, LatLng pos2) {
    double lat;
    double lng;
    if (pos1.latitude < pos2.latitude) {
      lat = pos1.latitude;
    } else {
      lat = pos2.latitude;
    }

    if (pos1.longitude < pos2.longitude) {
      lng = pos1.longitude;
    } else {
      lng = pos2.longitude;
    }
    return LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                Consumer<LocationModel>(
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
                        position: LatLng(
                            locationModel.pickUpLocationInfo.latitude,
                            locationModel.pickUpLocationInfo.longitude));

                    Marker dropOffMarker = new Marker(
                        markerId: MarkerId("drop"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueAzure),
                        infoWindow: InfoWindow(
                            title: "ETA: $timeOfArrival",
                            snippet:
                                "${locationModel.dropOffLocationInfo.formattedAddress.length > 30 ? locationModel.dropOffLocationInfo.formattedAddress.substring(0, 27) + "..." : locationModel.dropOffLocationInfo.formattedAddress}"),
                        position: LatLng(
                            locationModel.dropOffLocationInfo.latitude,
                            locationModel.dropOffLocationInfo.longitude));

                    markers.add(pickupMarker);
                    markers.add(dropOffMarker);

                    // the focusMapOnBound method focuses the map on the overview polyline
                    focusMapOnBound(GoogleMapController controller) {
                      LatLng pickup = LatLng(
                          locationModel.pickUpLocationInfo.latitude,
                          locationModel.pickUpLocationInfo.longitude);
                      LatLng dropOff = LatLng(
                          locationModel.dropOffLocationInfo.latitude,
                          locationModel.dropOffLocationInfo.longitude);
                      LatLngBounds bounds = new LatLngBounds(
                          southwest: calcSouthWestBound(pickup, dropOff),
                          northeast: calcNorthEastBound(pickup, dropOff));
                      CameraUpdate update =
                          CameraUpdate.newLatLngBounds(bounds, 100);
                      controller.animateCamera(update);
                      try {
                        controller.showMarkerInfoWindow(MarkerId("drop"));
                      } catch (err) {}
                    }

                    if (locationModel.overviewLines.length == 0) {
                      //the polyLineFetchStream continuously tries to get the polyline in case of a network fetch error
                      polyLineFetchStream = locationModel
                          .getOverViewPolyLines()
                          .asStream()
                          .listen((event) async {
                        while (locationModel.overviewLines.length == 0) {
                          fetchSuccess =
                              await locationModel.getOverViewPolyLines();
                          Timer(Duration(seconds: 1), () {
                            if (fetchSuccess) {
                              focusMapOnBound(mapController);
                              mapController
                                  .showMarkerInfoWindow(MarkerId("drop"));
                            }
                          });
                        }
                        polyLineFetchStream.cancel();
                      });
                    }

                    return GoogleMap(
                      key: mapKey,
                      onMapCreated: (controller) {
                        mapController = controller;
                        focusMapOnBound(controller);
                        Timer(Duration(seconds: 1), () {
                          if (locationModel.overviewLines.length > 0) {
                            controller.showMarkerInfoWindow(MarkerId("drop"));
                          }
                        });
                      },
                      initialCameraPosition: CameraPosition(
                          target: LatLng(
                              locationModel.pickUpLocationInfo.latitude,
                              locationModel.pickUpLocationInfo.longitude),
                          zoom: 11.0),
                      compassEnabled: false,
                      trafficEnabled: false,
                      myLocationEnabled: false,
                      zoomControlsEnabled: false,
                      rotateGesturesEnabled: false,
                      mapToolbarEnabled: true,
                      polylines: locationModel.overviewLines.length > 0
                          ? locationModel.overviewLines.toSet()
                          : null,
                      markers: locationModel.overviewLines.length > 0
                          ? Set<Marker>.of(markers)
                          : null,
                    );
                  },
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: height(context) * 0.03,
                        left: width(context) * 0.02),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height(context) * 0.4,
              width: width(context),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text('Choose a trip or swipe up for more'),
                  ),
                  Consumer<LocationModel>(
                    builder: (context, locationModel, _) {
                      if (locationModel.overviewLines.length == 0) {
                        return LinearProgressIndicator();
                      }
                      return Divider();
                    },
                  ),
                  Container(
                    height: height(context) * 0.1,
                    width: width(context),
                    padding: EdgeInsets.only(top: 10, bottom: 10),
//                    color: Colors.grey[200],
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
//                          height: 50, width: 50,
                              color: Colors.transparent,
                              child: Image.asset(
                                'images/cars.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'UberX  ',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Icon(
                                        Icons.person,
                                        size: 14,
                                      ),
                                      Text(
                                        '4',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                  Text(
                                    '6:09pm drop-off',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 30, right: 10),
                          child: Text(
                            'NGN 850.00',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: height(context) * 0.1,
                    width: width(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.credit_card,
                              size: 24,
                              color: Colors.black,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                'Ride Cash -',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 14,
                        )
                      ],
                    ),
                  ),
                  RaisedButton(
                    child: Text(
                      'Confirm Ride',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                    color: Colors.black,
                    onPressed: () {},
                    padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 120),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
