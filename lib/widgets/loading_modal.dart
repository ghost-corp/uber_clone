import 'package:flutter/material.dart';
import 'package:uber_clone/global/screen_size.dart';

class LoadingModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(context),
      width: width(context),
      color: Color.fromARGB(100, 0, 0, 0),
      child: Center(
        child: Container(
          height: 60,
          width: width(context) * 0.6,
          color: Colors.white,
          child: Center(
            child: SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
