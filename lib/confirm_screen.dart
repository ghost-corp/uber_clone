import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/api/polyline_api.dart';
import 'package:uber_clone/global/screen_size.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/models/location_model.dart';
import 'package:uber_clone/models/trip_model.dart';
import 'package:uber_clone/widgets/overview.dart';

class ConfirmPickUpScreen extends StatelessWidget {
  final GlobalKey mapKey = new GlobalKey();
  final GlobalKey<ConfirmScreenBottomNavState> bottomNavKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    var locationModel = Provider.of<LocationModel>(context, listen: false);
    return WillPopScope(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  DistanceOverview(
                    firstLocation: LatLng(
                        locationModel.pickUpLocationInfo.latitude,
                        locationModel.pickUpLocationInfo.longitude),
                    secondLocation: LatLng(
                        locationModel.dropOffLocationInfo.latitude,
                        locationModel.dropOffLocationInfo.longitude),
                    firstLocationInfoWindow: InfoWindow(
                        title: "Pickup Location",
                        snippet:
                            locationModel.pickUpLocationInfo.formattedAddress),
                    secondLocationInfoWindow: InfoWindow(
                        title: "ETA: $timeOfArrival",
                        snippet:
                            locationModel.dropOffLocationInfo.formattedAddress),
                    onPolylineDrawn: () {
                      bottomNavKey.currentState.setState(() {
                        bottomNavKey.currentState.showOverviewLoadingIndicator =
                            false;
                      });
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
                          Provider.of<TripModel>(context, listen: false)
                              .setConnectingToDriver(false);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ConfirmScreenBottomNav(key: bottomNavKey),
            )
          ],
        ),
      ),
      onWillPop: () async {
        Provider.of<TripModel>(context, listen: false)
            .setConnectingToDriver(false);
        return false;
      },
    );
  }
}

class ConfirmScreenBottomNav extends StatefulWidget {
  ConfirmScreenBottomNav({Key key}) : super(key: key);
  @override
  State createState() => ConfirmScreenBottomNavState();
}

class ConfirmScreenBottomNavState extends State<ConfirmScreenBottomNav> {
  bool showOverviewLoadingIndicator = true;
  bool confirmedButtonPressed = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(context) * 0.35,
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
          showOverviewLoadingIndicator ? LinearProgressIndicator() : Divider(),
          Expanded(
            child: Container(
              width: width(context),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.transparent,
                            child: Image.asset(
                              'images/cars.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
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
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      'NGN 850.00',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          ),
          confirmedButtonPressed ? LinearProgressIndicator() : Divider(),
          Expanded(
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: confirmedButtonPressed
                    ? Center(
                        child: Text(
                          "Connecting to Driver",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: width(context),
                            padding: EdgeInsets.only(bottom: 10),
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
                          Expanded(
                            child: RaisedButton(
                              child: Text(
                                'Confirm Ride',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17),
                              ),
                              color: Colors.black,
                              onPressed: () {
                                setState(() {
                                  confirmedButtonPressed = true;
                                });
                                Provider.of<LocationModel>(context,
                                        listen: false)
                                    .sendRideRequests();
                              },
                              padding: EdgeInsets.symmetric(
                                  horizontal: width(context) * 0.25),
                            ),
                          )
                        ],
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
