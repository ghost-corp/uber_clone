import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/api/search_api.dart';
import 'package:uber_clone/global/screen_size.dart';
import 'package:uber_clone/models/location_model.dart';

class PickUpLocation extends StatefulWidget {
  @override
  _PickUpLocationState createState() => _PickUpLocationState();
}

class _PickUpLocationState extends State<PickUpLocation> {
  GoogleMapController mapController;
  Place pickUpSpot;
  LatLng markerLocation;
  StreamSubscription searchStream;
  int buildCount = 0;
  bool fetchingInfo = false;
  GlobalKey mapKey = new GlobalKey();

  void getSearchResult(LatLng location) {
    setState(() {
      fetchingInfo = true;
    });
    if (searchStream != null) {
      try {
        searchStream.cancel();
      } catch (err) {}
    }
    searchStream = SearchApi.convertCoordinatesToAddress(location)
        .asStream()
        .listen((result) {
      setState(() {
        pickUpSpot = result;
        fetchingInfo = false;
      });
      if (searchStream != null) {
        searchStream.cancel();
      }
    });
  }

  @override
  void dispose() {
    if (searchStream != null) {
      searchStream.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //set markerLocation and pickupSpot on first build only to allow it to be changed later on
    if (buildCount == 0) {
      pickUpSpot =
          Provider.of<LocationModel>(context, listen: false).pickUpLocationInfo;
      markerLocation = LatLng(
          Provider.of<LocationModel>(context, listen: false)
              .currentLocation
              .latitude,
          Provider.of<LocationModel>(context, listen: false)
              .currentLocation
              .longitude);
    }
    if (buildCount < 1) {
      buildCount++;
    }

    if (Provider.of<LocationModel>(context, listen: false).currentLocation ==
        null) {
      return Container();
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  key: mapKey,
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          markerLocation.latitude, markerLocation.longitude),
                      zoom: 16.0),
                  trafficEnabled: false,
                  onCameraMove: (center) {
                    setState(() {
                      markerLocation = LatLng(center.toMap()['target'][0],
                          center.toMap()['target'][1]);
                    });
                  },
                  onCameraIdle: () {
                    getSearchResult(markerLocation);
                  },
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  markers: Set<Marker>.of(<Marker>[
                    Marker(
                        markerId: MarkerId("1"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueAzure),
                        position: markerLocation)
                  ]),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 30, left: 5),
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
              height: height(context) * 0.3,
              width: width(context),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: height(context) * 0.02,
                        bottom: height(context) * 0.02),
                    child: Center(
                      child: Text(
                        'Set your pick-up location',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  fetchingInfo
                      ? LinearProgressIndicator()
                      : Divider(
                          thickness: 1.5,
                        ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '${pickUpSpot.name}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        FlatButton(
                          child: Text(
                            'Search',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          onPressed: () {},
                          color: Colors.grey[200],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: height(context) * 0.02),
                    child: FlatButton(
                      onPressed: () {
                        if (fetchingInfo != true) {
                          Provider.of<LocationModel>(context, listen: false)
                              .setPickupLocationInfo(pickUpSpot);
                          Provider.of<LocationModel>(context, listen: false)
                              .resetOverviewLine();
                          Navigator.of(context).pushNamed("confirm_screen");
                        }
                      },
                      child: Text(
                        'CONFIRM PICK-UP',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    ),
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
