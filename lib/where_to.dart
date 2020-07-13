import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/api/search_api.dart';
import 'package:uber_clone/global/screen_size.dart';
import 'package:uber_clone/models/location_model.dart';

class WhereToScreen extends StatefulWidget {
  @override
  _WhereToScreenState createState() => _WhereToScreenState();
}

class _WhereToScreenState extends State<WhereToScreen> {
  bool doneButton = true;
  List<Place> searchResult = new List();
  bool fetchingResult = false;
  StreamSubscription searchStream;

  void getSearchResult(BuildContext context, String searchKey) {
    if (searchStream != null) {
      try {
        searchStream.cancel();
      } catch (err) {}
    }
    searchStream =
        SearchApi.searchPlace(context, searchKey).asStream().listen((result) {
      setState(() {
        searchResult = result;
      });
      if (searchStream != null) {
        searchStream.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.height,
          ),
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: LatLng(45.521, -122.677433), zoom: 11.0),
            compassEnabled: false,
            trafficEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
          ),
          Column(
            children: <Widget>[
              Material(
                elevation: 4,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.18,
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03,
                    right: 20,
                  ),
                  child: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30, right: 30),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(bottom: 5),
                              height: 35,
                              width: MediaQuery.of(context).size.width * 0.76,
                              child: Consumer<LocationModel>(
                                builder: (context, locationModel, _) {
                                  TextEditingController controller =
                                      new TextEditingController(
                                          text: locationModel
                                              .currentLocationInformation
                                              .formattedAddress);
                                  return TextField(
                                    controller: controller,
                                    onTap: () {
                                      setState(() {
                                        doneButton = false;
                                      });
                                    },
                                    readOnly: true,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[100])),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[100])),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[100]))),
                                  );
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              height: 35,
                              width: MediaQuery.of(context).size.width * 0.76,
                              child: TextField(
                                onTap: () {
                                  setState(() {
                                    doneButton = false;
                                  });
                                },
                                onChanged: (value) {
                                  getSearchResult(context, value);
                                },
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    focusColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey[200])),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey[200])),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey[200]))),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              searchResult == null
                  ? Container()
                  : searchResult.length > 0
                      ? Container(
                          color: Colors.white,
                          height: height(context) - height(context) * 0.6,
                          width: width(context),
                          child: ListView.builder(
                            itemCount: searchResult.length,
                            itemBuilder: (context, count) {
                              return ListTile(
                                title:
                                    Text(searchResult[count].formattedAddress),
                                subtitle: Text(searchResult[count].name),
                                leading: Icon(Icons.location_on),
                              );
                            },
                          ),
                        )
                      : Container(),
            ],
          ),
          doneButton
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: FlatButton(
                        child: Text(
                          'DONE',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        color: Colors.black,
                        onPressed: () {
                          Navigator.of(context).pushNamed("pickup_location");
                        },
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.18),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        doneButton = true;
                      });
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.82,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
