import 'package:polyline/polyline.dart' as poly;
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/global/api_key.dart';
import 'dart:convert';

import 'package:uber_clone/models/location_model.dart';

String timeOfArrival = "";

class PolylineApi {
  static Future<Map<String, dynamic>> getPolyLines(
      LatLng pickUp, LatLng dropOff) async {
    Map<String, dynamic> result = new Map();
    try {
      poly.Polyline polyline;
      print("here.....................");
      var response;
      try {
        response = await http.get(
            'https://maps.googleapis.com/maps/api/directions/json?origin=${pickUp.latitude},${pickUp.longitude}'
            '&destination=${dropOff.latitude},${dropOff.longitude}&key=$api_key');
      } catch (err) {
        print("first block");
        return null;
      }
      if (response.statusCode == 200) {
        print(response.body);
        print(json.decode(response.body));
        polyline = poly.Polyline.Decode(
            precision: 5,
            encodedString: json.decode(response.body)['routes'][0]
                ['overview_polyline']['points']);
        timeOfArrival = json.decode(response.body)['routes'][0]['legs'][0]
            ['duration']['text'];
        result.putIfAbsent("polyline", () => coordinatesConverter(polyline));
        List<Step> steps = new List();
        var stepsTemp =
            json.decode(response.body)['routes'][0]['legs'][0]['steps'];
        for (int x = 0; x < stepsTemp.length; x++) {
          steps.add(Step.fromJson(stepsTemp[x]));
        }
        result.putIfAbsent("steps", () => steps);
        print("returning map..............");
        return result;
      } else {
        print("failed..........................");
        return null;
      }
    } catch (err) {
      print(err + ".............................");
      return null;
    }
  }

  static List<LatLng> coordinatesConverter(poly.Polyline polyline) {
    var points = polyline.decodedCoords;
    List<LatLng> coordinates = new List();
    points.forEach((element) {
      coordinates.add(LatLng(element[0], element[1]));
    });
    return coordinates;
  }
}
