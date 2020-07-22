import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/api/search_api.dart';
import 'package:uber_clone/global/screen_size.dart';
import 'package:uber_clone/models/auth_model.dart';
import 'package:uber_clone/models/location_model.dart';
import 'package:uber_clone/widgets/map_location_selector.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  int buildCount = 0;
  Place address;
  LatLng markerLocation;
  bool fetchingInfo = false;
  GlobalKey<MapLocationSelectorState> locationSelectorKey = new GlobalKey();
  TextEditingController controller = TextEditingController();

  void getSearchResult() {
    setState(() {
      fetchingInfo = true;
    });
    SearchApi.convertCoordinatesToAddress(
        locationSelectorKey.currentState.markerLocation)
        .then((result) {
      setState(() {
        address = result;
        controller.text = address.name;
        fetchingInfo = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    if (buildCount == 0) {
      address =
          Provider.of<LocationModel>(context, listen: false).pickUpLocationInfo;
      markerLocation = LatLng(
          Provider.of<LocationModel>(context, listen: false)
              .currentLocation
              .latitude,
          Provider.of<LocationModel>(context, listen: false)
              .currentLocation
              .longitude);
    }
    if (buildCount < 1) {
      buildCount++;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
            padding: EdgeInsets.only(
                bottom: 3
            ),
            width: width(context) * 0.8,
            height: 40,
            child: TextFormField(
              controller: controller,
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
                          color: Colors.grey[100]))
              ),
            )
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: height(context),
            width: width(context),
          ),
          MapLocationSelector(
            initialLocation: markerLocation,
            key: locationSelectorKey,
            onCameraMove: () {
              getSearchResult();
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 15
              ),
              child: FlatButton(
                child: Text(
                  'DONE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 120, vertical: 15
                ),
                color: Colors.black,
                onPressed: () {
                  Provider.of<AuthModel>(context, listen: false).saveAddress(address);
                  Navigator.of(context).popUntil(
                    ModalRoute.withName("choose_saved")
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
