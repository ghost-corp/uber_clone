import 'package:flutter/material.dart';

class HomePageBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
            child: Center(
              child: Text(
                "Good morning, Abdulmalik",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
            ),
          ),
        ),
        Divider(
          thickness: 2,
        ),
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
          child: Center(
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed("where_to");
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.92,
                color: Colors.grey[300],
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Where to?",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.03,
              top: MediaQuery.of(context).size.height * 0.01),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('choose_saved');
            },
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height * 0.055,
                  ),
                  child: Icon(
                    Icons.stars,
                    color: Colors.grey,
                    size: MediaQuery.of(context).size.height * 0.05,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                  child: Text(
                    "Choose a saved place",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
