import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/api/search_api.dart';
import 'package:uber_clone/global/screen_size.dart';
import 'package:uber_clone/models/location_model.dart';
import 'package:uber_clone/widgets/map_location_selector.dart';

class WhereToScreen extends StatefulWidget {
  @override
  _WhereToScreenState createState() => _WhereToScreenState();
}

class _WhereToScreenState extends State<WhereToScreen> {
  bool doneButton = false;
  List<Place> searchResult = new List();
  bool fetchingResult = false;
  TextEditingController controller = new TextEditingController();
  TextEditingController destinationController = new TextEditingController();
  GlobalKey mapKey = new GlobalKey();
  String mapStyle;
  bool fetchingInfo = false;
  bool mapCapAlterField = false;
  int mapUpdateCount = 0;

  void getSearchResult(BuildContext context, String searchKey) {
    setState(() {
      fetchingInfo = true;
    });
    SearchApi.searchPlace(context, searchKey).then((result) {
      setState(() {
        searchResult = result;
        fetchingInfo = false;
      });
    });
  }

  //locationSelectorKey us used to access the selected location of the MapLocationSelectorWidget
  GlobalKey<MapLocationSelectorState> locationSelectorKey = new GlobalKey();

  void getSearchResultFromMap() {
    setState(() {
      fetchingInfo = true;
    });
    var search = SearchApi.convertCoordinatesToAddress(
        locationSelectorKey.currentState.markerLocation);
    search.then((result) {
      if (mapCapAlterField == true) {
        destinationController.clear();
      }
      Provider.of<LocationModel>(context, listen: false)
          .setDropOffLocationInfo(result);
      if (mapCapAlterField == true) {
        destinationController.text =
            Provider.of<LocationModel>(context, listen: false)
                .dropOffLocationInfo
                .name;
      }
      if (mapCapAlterField == true) {
        setState(() {
          doneButton = true;
        });
        FocusScope.of(context).requestFocus(new FocusNode());
      }
      setState(() {
        fetchingInfo = false;
      });
    });
    search.catchError((err) {
      setState(() {
        fetchingInfo = false;
      });
    });
  }

  void getMapStyle() async {
    String style = await rootBundle.loadString("assets/grey.json");
    if (mounted) {
      setState(() {
        mapStyle = style;
      });
    } else {
      mapStyle = style;
    }
  }

  @override
  void initState() {
    getMapStyle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> searchResultWidgets = new List();
    if (searchResult != null) {
      searchResult.forEach((result) {
        searchResultWidgets.add(InkWell(
          onTap: () {
            destinationController.clear();
            Provider.of<LocationModel>(context, listen: false)
                .setDropOffLocationInfo(result);
            destinationController.text =
                Provider.of<LocationModel>(context, listen: false)
                    .dropOffLocationInfo
                    .name;
            setState(() {
              doneButton = true;
            });
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider(),
              ListTile(
                title: Text(result.formattedAddress),
                subtitle: Text(result.name),
                leading: Icon(Icons.location_on),
              )
            ],
          ),
        ));
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.height,
          ),
          mapStyle == null
              ? Container()
              : MapLocationSelector(
                  initialLocation: LatLng(
                      Provider.of<LocationModel>(context, listen: false)
                          .currentLocation
                          .latitude,
                      Provider.of<LocationModel>(context, listen: false)
                          .currentLocation
                          .longitude),
                  key: locationSelectorKey,
                  onCameraMove: () {
                    if (mapCapAlterField == false && mapUpdateCount >= 1) {
                      setState(() {
                        mapCapAlterField = true;
                      });
                    }
                    if (mapUpdateCount < 2) {
                      mapUpdateCount++;
                    }
                    getSearchResultFromMap();
                  },
                ),
          doneButton == true
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
              : Container(
                  height: 0,
                  width: 0,
                ),
          Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Material(
                  elevation: 2,
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
                                    controller.text = locationModel
                                                .currentLocationInfo
                                                .formattedAddress !=
                                            ""
                                        ? locationModel.currentLocationInfo
                                            .formattedAddress
                                        : "Unknown Road";
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
                                  controller: destinationController,
                                  onTap: () {
                                    setState(() {
                                      doneButton = false;
                                    });
                                  },
                                  onChanged: (value) {
                                    getSearchResult(context, value);
                                  },
                                  autofocus: true,
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
                fetchingInfo == true
                    ? LinearProgressIndicator()
                    : Container(height: 0, width: 0),
                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('choose_saved');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.stars,
                              color: Colors.grey,
                              size: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Text(
                              "Choose a saved place",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        Icon(Icons.navigate_next)
                      ],
                    ),
                  ),
                ),
                searchResult == null || doneButton == true
                    ? Container()
                    : searchResult.length > 0
                        ? Container(
                            color: Colors.white,
                            width: width(context),
                            child: searchResultWidgets.length <= 5
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[...searchResultWidgets],
                                  )
                                : ListView(
                                    children: <Widget>[...searchResultWidgets],
                                  ),
                          )
                        : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
