import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/global/screen_size.dart';
import 'package:uber_clone/models/trip_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverInfo extends StatelessWidget {
  final Trip trip;
  DriverInfo({this.trip});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(context) * 0.3,
      color: Colors.white,
      width: width(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      shape:
                          CircleBorder(side: BorderSide(color: Colors.black)),
                      child: Icon(Icons.clear),
                      onPressed: () {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Not yet implemented"),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ));
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        'Cancel Ride',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Image.asset(
                    'images/cars.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Toyota Corolla',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        'BC123-BRC',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${trip.driverName}',
                style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              Text(
                '  .  ',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
              Row(
                children: <Widget>[
                  Text(
                    '5.0 ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.black,
                    size: 14,
                  )
                ],
              ),
              Text(
                '  .  ',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
              Text(
                'Knows English & French',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.call),
                onPressed: () {
                  var url = "tel:${trip.driverPhone}";
                  launch(url);
                },
              ),
              Container(
                width: width(context) * 0.6,
                height: 40,
                child: TextField(
                  onTap: () {
                    Navigator.of(context).pushNamed("chat_screen");
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          borderSide: BorderSide(color: Colors.grey[200])),
                      hintText: 'Any pickup notes?',
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.wb_sunny,
                  color: Colors.amber,
                ),
                onPressed: () {
                  //TODO
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
