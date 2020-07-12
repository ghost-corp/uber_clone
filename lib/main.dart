import 'package:flutter/material.dart';
import 'package:uber_clone/discount.dart';
import 'package:uber_clone/get_moving.dart';
import 'package:uber_clone/home.dart';
import 'package:uber_clone/payment.dart';
import 'package:uber_clone/phonenumber.dart';
import 'package:uber_clone/settings.dart';
import 'package:uber_clone/welcome_page.dart';
import 'phone_verification.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'mx ride',
      theme: ThemeData(primaryColor: Colors.black, accentColor: Colors.black),
//      home: WelcomePage(title: 'Uber'),
      home: HomePage(),
      routes: {
        "phone_sign_up": (context) => PhoneNumber(),
        "phone_verification_page": (context) => VerificationPage(),
        "get_moving": (context) => GetMoving(),
        "discount": (context) => Discount(),
        "settings": (context) => Settings(),
        "payment": (context) => Payment()
      },
    );
  }
}
