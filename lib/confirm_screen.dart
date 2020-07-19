import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/api/polyline_api.dart';
import 'package:uber_clone/global/screen_size.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/models/location_model.dart';
import 'package:uber_clone/widgets/overview.dart';

class ConfirmPickUpScreen extends StatefulWidget {
  @override
  _ConfirmPickUpScreenState createState() => _ConfirmPickUpScreenState();
}

class _ConfirmPickUpScreenState extends State<ConfirmPickUpScreen> {
  GlobalKey mapKey = new GlobalKey();
  GoogleMapController mapController;
  bool fetchSuccess;
  bool confirmedButtonPressed = false;

  Future<List<Polyline>> getPolyLine(BuildContext context) async {
    List<Polyline> line;
    try {
      var locationModel = Provider.of<LocationModel>(context, listen: false);
      line = await locationModel.getOverViewPolyLines();
      if (line == null) {
        return getPolyLine(context);
      }
      if (line.length == 0) {
        return getPolyLine(context);
      }
    } catch (err) {
      print(err);
    }
    return line;
  }

  @override
  Widget build(BuildContext context) {
    var locationModel = Provider.of<LocationModel>(context, listen: false);
    return Scaffold(
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
                    getPolyline: () => getPolyLine(context)),
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
                  Consumer<LocationModel>(
                    builder: (context, locationModel, _) {
                      if (locationModel.overviewLines.length == 0) {
                        return LinearProgressIndicator();
                      }
                      return Divider();
                    },
                  ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  confirmedButtonPressed
                      ? LinearProgressIndicator()
                      : Divider(),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                        Timer(Duration(seconds: 3), () {
                                          Navigator.popUntil(context,
                                              ModalRoute.withName('home_page'));
                                          Provider.of<LocationModel>(context,
                                                  listen: false)
                                              .setMapMode(MapMode
                                                  .DestinationNavigation);
                                        });
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
            ),
          )
        ],
      ),
    );
  }
}
