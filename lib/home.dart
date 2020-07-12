import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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
  Map<CircleId, Circle> circles = new Map();
  Location location = new Location();
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  @override
  void initState() {
    getLocation() async {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      locationData = await location.getLocation();
      setCameraPosition();
      setCircle();
    }

    getLocation();
    super.initState();
  }

  void setCameraPosition() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(locationData.latitude, locationData.longitude),
        zoom: 11.0)));
  }

  void setCircle() {
    String circleIdVal = 'nearbyCircle';
    CircleId circleId = CircleId(circleIdVal);
    Circle circle = Circle(
        circleId: circleId,
        consumeTapEvents: true,
        strokeColor: Color(0x262196F3),
        fillColor: Color.fromARGB(50, 74, 63, 250),
        strokeWidth: 0,
        radius: 9000,
        center: LatLng(locationData.latitude, locationData.longitude),
        onTap: () {});
    setState(() {
      circles.putIfAbsent(circleId, () => circle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(45.521, -122.677433), zoom: 11.0),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                compassEnabled: false,
                trafficEnabled: false,
                buildingsEnabled: false,
                circles: Set<Circle>.of(circles.values),
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
              )
            ],
          ),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
            child: Center(
              child: Text(
                "Good morning, Abdulmalik",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
            ),
          ),
        ),
        Divider(
          thickness: 2,
        ),
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
          child: Center(
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
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
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
  }
}
