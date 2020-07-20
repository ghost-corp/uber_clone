import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/api/polyline_api.dart';
import 'package:uber_clone/home/bottom_nav.dart';
import 'package:uber_clone/home/drawer_option.dart';
import 'package:uber_clone/home/nav_options.dart';
import 'package:uber_clone/models/driver_model.dart';
import 'package:uber_clone/models/location_model.dart';
import 'package:uber_clone/widgets/NavMap.dart';
import 'package:uber_clone/widgets/driver_info_overview.dart';
import 'package:uber_clone/widgets/overview.dart';

GlobalKey<ScaffoldState> key = new GlobalKey();

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.8,
        child: SideDrawerOption(),
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
                  if (locationModel.currentLocation == null) {
                    return Container();
                  }

                  if (locationModel.mapMode == MapMode.AwaitingDriver) {
                    LatLng pickup = LatLng(
                        locationModel.pickUpLocationInfo.latitude,
                        locationModel.pickUpLocationInfo.longitude);
                    Driver nearestDriver = locationModel.getNearestDriver();

                    Future<List<Polyline>> getPolyline() async {
                      Map result = await PolylineApi.getPolyLines(
                          pickup, nearestDriver.liveLocation);
                      List<LatLng> coords = result['polyline'];
                      List<Polyline> line = [
                        Polyline(
                            polylineId: PolylineId("driver distance"),
                            width: 3,
                            points: coords)
                      ];
                      if (line == null) {
                        return getPolyline();
                      }
                      if (line.length == 0) {
                        return getPolyline();
                      }
                      return line;
                    }

                    return DistanceOverview(
                      firstLocation: LatLng(
                          locationModel.pickUpLocationInfo.latitude,
                          locationModel.pickUpLocationInfo.longitude),
                      secondLocation: nearestDriver.liveLocation,
                      firstLocationMarkerIcon: driverIcon,
                      getPolyline: () => getPolyline(),
                    );
                  }

                  if (locationModel.mapMode == MapMode.DestinationNavigation) {
                    return NavMap(
                      onMenuTap: () {
                        key.currentState.openDrawer();
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
            if (locationModel.mapMode == MapMode.AwaitingDriver) {
              return DriverInfo();
            }
            return HomePageBottomNav();
          },
        )
      ],
    );
  }
}
