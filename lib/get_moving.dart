import 'package:flutter/material.dart';

class GetMoving extends StatefulWidget {
  @override
  _GetMovingState createState() => _GetMovingState();
}

class _GetMovingState extends State<GetMoving> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        //added listview beacuse the keypad overflows just before navigating
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.15),
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.175,
                      width: MediaQuery.of(context).size.height * 0.175,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(60.0)),
                          child: Image.asset("images/car.png"),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1,
                      left: MediaQuery.of(context).size.height * 0.015),
                  child: Text(
                    'Get moving faster with us',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.026,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03,
                    left: MediaQuery.of(context).size.width * 0.03,
                    right: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Text(
                    'For a more reliable trip, We collect location data from the time you open the app until a trip ends. ' +
                        'This improves pick-ups, support and more.',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.03,
                      left: MediaQuery.of(context).size.width * 0.03),
                  child: GestureDetector(
                    child: Text(
                      'Learn more',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: MediaQuery.of(context).size.height * 0.021),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: () {
          Navigator.pushNamed(context, "discount");
        },
      ),
    );
  }
}
