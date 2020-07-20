import 'package:flutter/material.dart';
import 'package:uber_clone/api/polyline_api.dart';

class NavOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      child: Container(
        color: Colors.white,
        height: 120,
//                  padding: EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              shape: CircleBorder(side: BorderSide(color: Colors.grey)),
              child: Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: () {
                //TODO
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  '$timeOfArrival',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                ),
                Text('8.4 km  3:39 pm')
              ],
            ),
            Row(
              children: <Widget>[
                FlatButton(
                  shape: CircleBorder(side: BorderSide(color: Colors.grey)),
                  child: Icon(
                    Icons.call_split,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    //TODO
                  },
                ),
                FlatButton(
                  shape: CircleBorder(side: BorderSide(color: Colors.grey)),
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    //TODO
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
