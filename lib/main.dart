import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:uber_clone/chat/chat_screen.dart';
import 'package:uber_clone/message_handler.dart' as myHandler;
import 'package:uber_clone/models/trip_model.dart';
import 'package:uber_clone/saved_places/choose_saved.dart';
import 'package:uber_clone/confirm_screen.dart';
import 'package:uber_clone/discount.dart';
import 'package:uber_clone/edit_account.dart';
import 'package:uber_clone/get_moving.dart';
import 'package:uber_clone/home/home.dart';
import 'package:uber_clone/models/location_model.dart';
import 'package:uber_clone/payment.dart';
import 'package:uber_clone/phonenumber.dart';
import 'package:uber_clone/pickup_location.dart';
import 'package:uber_clone/saved_places/search_screen.dart';
import 'package:uber_clone/settings.dart';
import 'package:uber_clone/welcome_page.dart';
import 'package:uber_clone/where_to.dart';
import 'package:uber_clone/saved_places/search_destination.dart';
import 'phone_verification.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/models/auth_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => LocationModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => AuthModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => TripModel(),
      )
    ],
    child: OverlaySupport(
      child: MyApp(),
    ),
  ));
}

GlobalKey<NavigatorState> navKey = GlobalKey();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navKey,
      title: 'Uber Clone',
      theme: ThemeData(primaryColor: Colors.black, accentColor: Colors.black),
      routes: {
        "phone_sign_up": (context) => PhoneNumber(),
        "phone_verification_page": (context) => VerificationPage(),
        "get_moving": (context) => GetMoving(),
        "discount": (context) => Discount(),
        "settings": (context) => Settings(),
        "payment": (context) => Payment(),
        "where_to": (context) => WhereToScreen(),
        "pickup_location": (context) => PickUpLocation(),
        "confirm_screen": (context) => ConfirmPickUpScreen(),
        "welcome_page": (context) => Consumer<AuthModel>(
              builder: (context, authModel, _) {
                if (authModel.user == null) {
                  return WelcomePage(title: "Uber Clone");
                }
                return myHandler.MessageHandler(child: HomePage());
              },
            ),
        "edit_account": (context) => EditAccount(),
        "choose_saved": (context) => ChooseSavedDestination(),
        "search_destination": (context) => SearchDestination(),
        "search_screen": (context) => SearchScreen(),
        "chat_screen": (context) => ChatScreen()
      },
      initialRoute: "welcome_page",
    );
  }
}
