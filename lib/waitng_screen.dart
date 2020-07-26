import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/api/polyline_api.dart';
import 'package:uber_clone/models/trip_model.dart';
import 'package:uber_clone/widgets/driver_info_overview.dart';
import 'package:uber_clone/widgets/overview.dart';

class WaitingScreen extends StatefulWidget {
  @override
  State createState() => WaitingScreenState();
}

class WaitingScreenState extends State<WaitingScreen> {
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
    if (buildCount == 0 && driverIcon == null) {
      initializeMarkerIcons();
    }
    if (buildCount < 1 && driverIcon != null) {
      buildCount++;
    }
    return Consumer<TripModel>(
      builder: (context, tripModel, _) {
        LatLng pickup = tripModel.currentTrip.pickupCoords;
        LatLng driverLocation = tripModel.currentTrip.driverCoords;

        return Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  DistanceOverview(
                    firstLocation: pickup,
                    secondLocation: driverLocation,
                    secondLocationMarkerIcon: driverIcon,
                  ),
                  SafeArea(
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
                  ),
                ],
              ),
            ),
            DriverInfo(
              trip: tripModel.currentTrip,
            ),
          ],
        );
      },
    );
  }
}
