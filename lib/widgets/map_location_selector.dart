import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocationSelector extends StatefulWidget {
  final Function onCameraMove;
  final LatLng initialLocation;

  MapLocationSelector({this.onCameraMove, this.initialLocation, Key key})
      : super(key: key);
  @override
  State createState() => MapLocationSelectorState();
}

class MapLocationSelectorState extends State<MapLocationSelector> {
  GoogleMapController mapController;
  LatLng markerLocation;
  Function onCameraMove;

  @override
  void initState() {
    onCameraMove = widget.onCameraMove;
    markerLocation = widget.initialLocation;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
      },
      initialCameraPosition: CameraPosition(
          target: LatLng(markerLocation.latitude, markerLocation.longitude),
          zoom: 16.0),
      trafficEnabled: false,
      onCameraMove: (center) {
        setState(() {
          markerLocation =
              LatLng(center.toMap()['target'][0], center.toMap()['target'][1]);
        });
      },
      onCameraIdle: () {
        onCameraMove();
      },
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      markers: Set<Marker>.of(<Marker>[
        Marker(
            markerId: MarkerId("1"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            position: markerLocation)
      ]),
    );
  }
}
