import 'package:flutter/material.dart';

class NavCenterButton extends StatelessWidget {
  final VoidCallback onTap;
  NavCenterButton({this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.navigation,
                size: 25,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Center",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
