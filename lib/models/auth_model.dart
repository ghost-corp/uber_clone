import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthModel extends ChangeNotifier {
  FirebaseUser user;
  StreamSubscription authStateStream;
  String verificationId;
  AuthProgress authProgress = AuthProgress.neutral;

  AuthModel() {
    authStateStream = FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      this.user = user;
      notifyListeners();
    });
  }

  void cancelAuthStream() {
    authStateStream.cancel();
  }

  Future<void> signUpWithPhoneNumber(
      String phoneNumber, BuildContext context) async {
    authProgress = AuthProgress.sendingVerificationCode;
    notifyListeners();
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(minutes: 2),
        verificationCompleted: (authCredentials) {},
        verificationFailed: (authException) {
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
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          this.verificationId = verificationId;
          authProgress = AuthProgress.verificationCodeSent;
          Navigator.pushNamed(context, "phone_verification_page");
        },
        codeAutoRetrievalTimeout: (value) {
          print(value);
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
}

enum AuthProgress {
  sendingVerificationCode,
  verificationCodeSent,
  errorSendingVerificationCode,
  invalidVerificationCode,
  verifying,
  neutral
}
