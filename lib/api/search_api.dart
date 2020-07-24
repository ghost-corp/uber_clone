import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:uber_clone/global/api_key.dart';
import 'package:uber_clone/models/location_model.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchApi {
  static Future<List<Place>> searchPlace(
      BuildContext context, String searchKey) async {
    List<Place> searchResult = new List();
    http.Response response = await http.get(
        "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?"
        "input=$searchKey&inputtype=textquery&fields=formatted_address,name,place_id,geometry&"
        "key=$api_key&"
        "locationbias=point:${Provider.of<LocationModel>(context, listen: false).currentLocation.latitude},"
        "${Provider.of<LocationModel>(context, listen: false).currentLocation.longitude}");
    if (response.statusCode == 200) {
      Map<String, dynamic> formattedResponse =
          JsonDecoder().convert(response.body);
      if (formattedResponse['status'] == "OK") {
        for (int x = 0; x < formattedResponse['candidates'].length; x++) {
          Place temp = Place.fromJson(formattedResponse['candidates'][x]);
          temp.latitude =
              formattedResponse['candidates'][x]['geometry']['location']['lat'];
          temp.longitude =
              formattedResponse['candidates'][x]['geometry']['location']['lng'];
          searchResult.add(temp);
        }
        return searchResult;
      } else {
        print(JsonDecoder().convert(response.body));
        return null;
      }
    } else {
      print(JsonDecoder().convert(response.body));
      return null;
    }
  }

  static Future<Place> convertCoordinatesToAddress(LatLng coordinates) async {
    Place searchResult;
    http.Response response = await http.get(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${coordinates.latitude},${coordinates.longitude}&key=$api_key");
    if (response.statusCode == 200) {
      Map<String, dynamic> formattedResponse =
          JsonDecoder().convert(response.body);
      if (formattedResponse['status'] == "OK") {
        searchResult = Place(
            formattedAddress: formattedResponse['results'][0]
                ['formatted_address'],
            name: formattedResponse['results'][0]['formatted_address'],
            placeId: formattedResponse['results'][0]['place_id']);
        searchResult.latitude =
            formattedResponse['results'][0]['geometry']['location']['lat'];
        searchResult.longitude =
            formattedResponse['results'][0]['geometry']['location']['lng'];
        return searchResult;
      } else {
        print(JsonDecoder().convert(response.body));
        return null;
      }
    } else {
      print(JsonDecoder().convert(response.body));
      return null;
    }
  }
}

class Place {
  String formattedAddress;
  String name;
  String placeId;
  double latitude;
  double longitude;

  Place(
      {this.placeId = "",
      this.name = "",
      this.formattedAddress = "",
      this.latitude = 0.0,
      this.longitude = 0.0});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
        formattedAddress: json['formatted_address'],
        name: json['name'],
        placeId: json['place_id']);
  }
}
