import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:uber_clone/models/auth_model.dart';

String fcmToken;

class MessageHandler extends StatefulWidget {
  final Widget child;
  MessageHandler({this.child});
  @override
  State createState() => MessageHandlerState();
}

class MessageHandlerState extends State<MessageHandler> {
  final Firestore db = Firestore.instance;
  final FirebaseMessaging fm = FirebaseMessaging();
  Widget child;
  @override
  void initState() {
    super.initState();
    child = widget.child;
    fm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showSimpleNotification(
            Text(
              message['notification']['title'],
              style: TextStyle(color: Colors.black),
            ),
            background: Colors.white,
            elevation: 5);
        //Scaffold.of(context).showSnackBar(snackbar);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        showSimpleNotification(
            Text(
              message['notification']['title'],
              style: TextStyle(color: Colors.black),
            ),
            background: Colors.white,
            elevation: 5);
        //Scaffold.of(context).showSnackBar(snackbar);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        showSimpleNotification(
            Text(
              message['notification']['title'],
              style: TextStyle(color: Colors.black),
            ),
            background: Colors.white,
            elevation: 5);
      },
    );
    saveDeviceToken() async {
      fcmToken = await fm.getToken();
      if (fcmToken != null) {
        var tokenRef = Firestore.instance
            .collection("users")
            .document(Provider.of<AuthModel>(context, listen: false).user.uid)
            .collection("tokens")
            .document("deviceToken");

        await tokenRef.setData({
          'token': fcmToken,
          "createdAt": FieldValue.serverTimestamp(),
          "platform": Platform.operatingSystem
        });
      }
    }

    saveDeviceToken();
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
