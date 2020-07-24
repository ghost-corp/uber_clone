import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/api/polyline_api.dart';
import 'package:uber_clone/models/driver_model.dart';
import 'package:uber_clone/models/location_model.dart';
import 'package:uber_clone/models/trip_model.dart';
import 'package:uber_clone/widgets/driver_info_overview.dart';
import 'package:uber_clone/widgets/overview.dart';

class WaitingScreen extends StatefulWidget {
  @override
  State createState() => WaitingScreenState();
}

class WaitingScreenState extends State<WaitingScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TripModel>(
      builder: (context, tripModel, _) {
        var locationModel = Provider.of<LocationModel>(context, listen: false);
        LatLng pickup = tripModel.currentTrip.pickupCoords;
        Driver nearestDriver = locationModel.getNearestDriver();
        print(pickup.toJson());
        print(nearestDriver.liveLocation.toJson());

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

        return Column(
          children: <Widget>[
            Expanded(
              child: DistanceOverview(
                firstLocation: pickup,
                secondLocation: nearestDriver.liveLocation,
//          firstLocationMarkerIcon: driverIcon,
                getPolyline: () => getPolyline(),
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
