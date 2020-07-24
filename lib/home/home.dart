import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/confirm_screen.dart';
import 'package:uber_clone/home/bottom_nav.dart';
import 'package:uber_clone/home/drawer_option.dart';
import 'package:uber_clone/home/nav_options.dart';
import 'package:uber_clone/models/location_model.dart';
import 'package:uber_clone/models/trip_model.dart';
import 'package:uber_clone/waitng_screen.dart';
import 'package:uber_clone/widgets/NavMap.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> key = new GlobalKey();
    return Scaffold(
      key: key,
      drawer: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.8,
        child: SideDrawerOption(),
      ),
      body: Consumer<TripModel>(
        builder: (context, tripModel, _) {
          if (tripModel.connectToDriver == true) {
            return ConfirmPickUpScreen();
          }

          if (tripModel.currentTrip == null) {
            return HomeBody(scaffoldKey: key);
          }
          return WaitingScreen();
        },
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  HomeBody({this.scaffoldKey});
  @override
  State createState() => HomeBodyState();
}

class HomeBodyState extends State<HomeBody> {
  GlobalKey<ScaffoldState> scaffoldKey;
  GoogleMapController mapController;
  GlobalKey mapKey = new GlobalKey();
  BitmapDescriptor driverIcon;
  int buildCount = 0;

  @override
  void initState() {
    scaffoldKey = widget.scaffoldKey;
    super.initState();
  }

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
                  if (locationModel.currentLocation == null) {
                    return Container();
                  }

                  if (locationModel.mapMode == MapMode.DestinationNavigation) {
                    return NavMap(
                      onMenuTap: () {
                        scaffoldKey.currentState.openDrawer();
                      },
                    );
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
              return NavOptions();
            }
            return HomePageBottomNav();
          },
        ),
      ],
    );
  }
}
