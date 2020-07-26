import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/api/search_api.dart';
import 'package:uber_clone/models/auth_model.dart';
import 'package:uber_clone/models/location_model.dart';

class ChooseSavedDestination extends StatefulWidget {
  @override
  _ChooseSavedDestinationState createState() => _ChooseSavedDestinationState();
}

class _ChooseSavedDestinationState extends State<ChooseSavedDestination> {
  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<AuthModel>(context, listen: false).user.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Choose a destination',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w300, color: Colors.black),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(userId)
            .collection('saved places')
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.hasError ||
              snapshot.data.documents.isEmpty)
            return ListView(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Add saved place',
                    style: TextStyle(color: Colors.indigo),
                  ),
                  subtitle: Text(
                    'Get to your favourite destination faster',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed("search_destination");
                  },
                ),
                Divider()
              ],
            );

          List<Place> places = [];
          List<Widget> placeWidget;

          snapshot.data.documents.forEach((element) {
            places.add(Place.fromJson(element.data));
          });

          placeWidget = places
              .map((e) => GestureDetector(
                    onTap: () {
                      Provider.of<LocationModel>(context, listen: false)
                          .setDropOffLocationInfo(e);
                      Navigator.of(context).pushNamed("pickup_location");
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Text(e.formattedAddress),
                          subtitle: Text(e.name),
                        ),
                        Divider()
                      ],
                    ),
                  ))
              .toList();

          return ListView(
            children: <Widget>[
              ...placeWidget,
              ListTile(
                title: Text(
                  'Add saved place',
                  style: TextStyle(color: Colors.indigo),
                ),
                subtitle: Text(
                  'Get to your favourite destination faster',
                  style: TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed("search_destination");
                },
              ),
              Divider()
            ],
          );
        },
      ),
    );
  }
}
