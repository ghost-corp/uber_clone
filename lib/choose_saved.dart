import 'package:flutter/material.dart';

class ChooseSavedDestination extends StatefulWidget {
  @override
  _ChooseSavedDestinationState createState() => _ChooseSavedDestinationState();
}

class _ChooseSavedDestinationState extends State<ChooseSavedDestination> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Choose a destination',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w300,
            color: Colors.black
          ),
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
            title: Text(
              'Add saved place',
              style: TextStyle(
                color: Colors.indigo
              ),
            ),
            subtitle: Text(
              'Get to your favourite destination faster',
              style: TextStyle(
                color: Colors.grey
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed("search_destination");
            },
          ),
          Divider()
        ],
      ),
    );
  }
}
