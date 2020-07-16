import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/api/polyline_api.dart';
import 'package:uber_clone/models/location_model.dart';
import 'package:uber_clone/widgets/NavMap.dart';

import 'models/location_model.dart';
import 'models/location_model.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.14,
                          left: MediaQuery.of(context).size.width * 0.01,
                          bottom: MediaQuery.of(context).size.width * 0.01,
                          right: MediaQuery.of(context).size.width * 0.01),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.width * 0.2,
                          ),
                          Padding(
                            padding: EdgeInsets.all(3),
                            child: Text(
                              "Abdulmalik Abubakar",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.01),
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.width * 0.03,
                          left: MediaQuery.of(context).size.width * 0.04),
                      child: Text(
                        "Do more with your account",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.01),
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.width * 0.05,
                          left: MediaQuery.of(context).size.width * 0.04),
                      child: Text(
                        "Make money driving",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              child: Text(
                "Your trips",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              child: Text(
                "Help",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "payment");
              },
              child: Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                child: Text(
                  "Payment",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.05),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              child: Text(
                "Free trips",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "settings");
                },
                child: Text(
                  "Settings",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.05),
                ),
              ),
            )
          ],
        ),
      ),
      body: HomeBody(),
    );
  }
}

class HomeBody extends StatefulWidget {
  @override
  State createState() => HomeBodyState();
}

class HomeBodyState extends State<HomeBody> {
  GoogleMapController mapController;
  GlobalKey mapKey = new GlobalKey();
  BitmapDescriptor driverIcon;
  int buildCount = 0;

  void initializeMarkerIcons() {
    if (driverIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(10, 10));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/taxi.png")
          .then((value) {
        setState(() {
          driverIcon = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (buildCount == 0) {
      initializeMarkerIcons();
    }
    if (buildCount < 1) {
      buildCount++;
    }
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              Consumer<LocationModel>(
                builder: (context, locationModel, child) {
                  if (locationModel.mapMode == MapMode.DestinationNavigation) {
                    return NavMap();
                  }

                  //creates the nearby location circle
                  String circleIdVal = 'nearbyCircle';
                  CircleId circleId = CircleId(circleIdVal);
                  Circle circle;
                  if (locationModel.currentLocation != null) {
                    circle = Circle(
                        circleId: circleId,
                        consumeTapEvents: true,
                        strokeColor: Color(0x262196F3),
                        fillColor: Color(0x262196F3),
                        strokeWidth: 0,
                        radius: 6000,
                        center: LatLng(locationModel.currentLocation.latitude,
                            locationModel.currentLocation.longitude),
                        onTap: () {});
                  }

                  //creates markers to be placed on the map for each driver
                  List<Marker> drivers = new List();
                  for (int x = 0; x < locationModel.nearbyDrivers.length; x++) {
                    drivers.add(Marker(
                        markerId: MarkerId("marker_$x"),
                        position: locationModel.nearbyDrivers[x].liveLocation,
                        icon: driverIcon));
                  }

                  if (locationModel.currentLocation == null) {
                    return Container();
                  }

                  return GoogleMap(
                    key: mapKey,
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                        target: LatLng(locationModel.currentLocation.latitude,
                            locationModel.currentLocation.longitude),
                        zoom: 12.0),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    trafficEnabled: false,
                    buildingsEnabled: false,
                    circles: circle == null ? null : Set<Circle>.of([circle]),
                    markers:
                        drivers.length == 0 ? null : Set<Marker>.of(drivers),
                  );
                },
              ),
              Consumer<LocationModel>(
                builder: (_, locationModel, __) {
                  if (locationModel.mapMode == MapMode.DestinationNavigation) {
                    return Container();
                  }
                  return SafeArea(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Icon(
                            Icons.menu,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
        Consumer<LocationModel>(
          builder: (_, locationModel, __) {
            if (locationModel.mapMode == MapMode.DestinationNavigation) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        locationModel.dropOffLocationInfo.formattedAddress,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text("ETA: $timeOfArrival")
                  ],
                ),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.02),
                    child: Center(
                      child: Text(
                        "Good morning, Abdulmalik",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                Padding(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.015),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("where_to");
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.92,
                        color: Colors.grey[300],
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Where to?",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height * 0.055,
                      bottom: MediaQuery.of(context).size.height * 0.03,
                      top: MediaQuery.of(context).size.height * 0.01),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.stars,
                        color: Colors.grey,
                        size: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.01),
                        child: Text(
                          "Choose a saved place",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        )
      ],
    );
  }
}
