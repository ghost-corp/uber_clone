import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber_clone/discount.dart';
import 'package:uber_clone/get_moving.dart';
import 'package:uber_clone/home.dart';
import 'package:uber_clone/models/location_model.dart';
import 'package:uber_clone/payment.dart';
import 'package:uber_clone/phonenumber.dart';
import 'package:uber_clone/settings.dart';
import 'phone_verification.dart';
import 'package:provider/provider.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context)=>LocationModel(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uber Clone',
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
