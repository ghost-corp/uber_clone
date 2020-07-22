import 'package:flutter/material.dart';
import 'package:uber_clone/global/screen_size.dart';

class SearchDestination extends StatefulWidget {
  @override
  _SearchDestinationState createState() => _SearchDestinationState();
}

class _SearchDestinationState extends State<SearchDestination> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          padding: EdgeInsets.only(
            bottom: 3
          ),
          width: width(context) * 0.8,
            height: 40,
            child: TextField(
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
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.gps_fixed,
              size: 30,
            ),
            title: Text(
              'Set location on map'
            ),
            onTap: () {
              Navigator.of(context).pushNamed("search_screen");
            },
          ),
          Divider()
        ],
      ),
    );
  }
}
