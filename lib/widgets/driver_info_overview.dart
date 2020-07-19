import 'package:flutter/material.dart';
import 'package:uber_clone/global/screen_size.dart';

class DriverInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(context) * 0.3,
      color: Colors.white,
      width: width(context),
    );
  }
}
