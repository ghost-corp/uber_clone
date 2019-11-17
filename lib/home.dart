import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black
              ),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                            Icons.account_circle,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width*0.18,
                        ),
                        Padding(
                          padding: EdgeInsets.all(3),
                          child: Text(
                            'Abdulmalik Abubakar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width*0.048
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Text(
                        "Do more with your account",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0, top: 12),
                      child: Text(
                        "Make money while driving",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Your trips",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width*0.045
                ),
              ),
              onTap: null,
            ),
            ListTile(
              title: Text(
                "Help",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width*0.045
                ),
              ),
              onTap: null,
            ),
            ListTile(
              title: Text(
                "Payment",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width*0.045
                ),
              ),
              onTap: null,
            ),
            ListTile(
              title: Text(
                "Free trips",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width*0.045
                ),
              ),
              onTap: null,
            ),
            ListTile(
              title: Text(
                "Your trips",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width*0.045
                ),
              ),
              onTap: null,
            ),
            ListTile(
              title: Text(
                "Settings",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width*0.045
                ),
              ),
              onTap: null,
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
