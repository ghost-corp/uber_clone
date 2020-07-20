import 'package:flutter/material.dart';

class SideDrawerOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.14,
                      left: MediaQuery.of(context).size.width * 0.01,
                      bottom: MediaQuery.of(context).size.width * 0.01,
                      right: MediaQuery.of(context).size.width * 0.01),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.width * 0.2,
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: Text(
                          "Abdulmalik Abubakar",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.white,
              ),
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.width * 0.03,
                      left: MediaQuery.of(context).size.width * 0.04),
                  child: Text(
                    "Do more with your account",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.width * 0.05,
                      left: MediaQuery.of(context).size.width * 0.04),
                  child: Text(
                    "Make money driving",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
          child: Text(
            "Your trips",
            style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.05),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
          child: Text(
            "Help",
            style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.05),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "payment");
          },
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
            child: Text(
              "Payment",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
          child: Text(
            "Free trips",
            style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.05),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "settings");
            },
            child: Text(
              "Settings",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
          ),
        )
      ],
    );
  }
}
