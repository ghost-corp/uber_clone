import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthModel extends ChangeNotifier {
  FirebaseUser user;
  UserDetails userDetails;
  StreamSubscription authStateStream;
  StreamSubscription userDetailsSub;
  String verificationId;
  AuthProgress authProgress = AuthProgress.neutral;

  AuthModel() {
    authStateStream = FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      this.user = user;
      notifyListeners();
      try {
        if (user != null) {
          userDetailsSub = _getUserDetails().asStream().listen((val) {
            userDetails = val;
            notifyListeners();
          });
        }
      } catch (err) {
        print(err);
      }
    });
  }

  void cancelAuthStream() {
    authStateStream.cancel();
    userDetailsSub.cancel();
  }

  void setAuthProgress(AuthProgress progress) {
    authProgress = progress;
    notifyListeners();
  }

  Future<void> authenticateWithPhoneNumber(
      String phoneNumber, BuildContext context) async {
    authProgress = AuthProgress.sendingVerificationCode;
    notifyListeners();
    await FirebaseAuth.instance
        .verifyPhoneNumber(
            phoneNumber: phoneNumber,
            timeout: Duration(minutes: 2),
            verificationCompleted: (credential) {
              _signInWithCredentials(credential, context);
            },
            verificationFailed: (authException) {
              print(authException.message);
              authProgress = AuthProgress.errorSendingVerificationCode;
              notifyListeners();
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("Error sending verification code")
                        ],
                      ),
                    );
                  });
            },
            codeSent: (String verificationId, [int forceResendingToken]) {
              this.verificationId = verificationId;
              authProgress = AuthProgress.verificationCodeSent;
              Navigator.pushNamed(context, "phone_verification_page");
            },
            codeAutoRetrievalTimeout: (value) {
              print("timeout");
            })
        .catchError((err) {
      authProgress = AuthProgress.errorSendingVerificationCode;
      notifyListeners();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[Text("Error sending verification code")],
              ),
            );
          });
    });
  }

  void signInVerificationCode(String code, BuildContext context) async {
    authProgress = AuthProgress.verifying;
    notifyListeners();
    AuthCredential credential;
    try {
      credential = PhoneAuthProvider.getCredential(
          verificationId: verificationId, smsCode: code.trim());
    } catch (err) {
      authProgress = AuthProgress.invalidVerificationCode;
      notifyListeners();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[Text("Invalid Code")],
              ),
            );
          });
    }
    _signInWithCredentials(credential, context);
  }

  void _signInWithCredentials(AuthCredential credential, BuildContext context) {
    var futureResult = FirebaseAuth.instance.signInWithCredential(credential);
    futureResult.catchError((err) {
      authProgress = AuthProgress.invalidVerificationCode;
      notifyListeners();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[Text("Invalid Code")],
              ),
            );
          });
    });
    futureResult.then((authResult) {
      Navigator.popUntil(context, ModalRoute.withName('welcome_page'));
    });
  }

  Future<UserDetails> _getUserDetails() async {
    UserDetails detailsTemp;
    while (detailsTemp == null) {
      try {
        var snapshot = await Firestore.instance
            .collection("users")
            .document(user.uid)
            .get()
            .catchError((err) {
          print(err);
        });
        if (snapshot.data == null) {
          detailsTemp = UserDetails();
        }
        detailsTemp = UserDetails.fromJson(snapshot.data);
      } catch (err) {
        print(err);
      }
    }
    return detailsTemp;
  }
}

class UserDetails {
  String firstName;
  String lastName;
  String phoneNumber;

  UserDetails({this.phoneNumber = "", this.lastName = "", this.firstName = ""});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
        firstName: json['firstName'],
        lastName: json['lastName'],
        phoneNumber: json['phoneNumber']);
  }
}

enum AuthProgress {
  sendingVerificationCode,
  verificationCodeSent,
  errorSendingVerificationCode,
  invalidVerificationCode,
  verifying,
  neutral
}
