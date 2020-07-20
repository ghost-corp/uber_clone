import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/models/auth_model.dart';
import 'package:uber_clone/widgets/loading_modal.dart';

class VerificationPage extends StatefulWidget {
  @override
  State createState() => VerificationPageState();
}

class VerificationPageState extends State<VerificationPage> {
  TextEditingController pinCodeController = TextEditingController();
  bool hasError = false;
  bool codeComplete = false;
  @override
  Widget build(BuildContext context) {
    String phoneNumber = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20, top: 12),
                              child: Text(
                                'Enter the 4-digit code sent to you at',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.055,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20, top: 12),
                              child: Text(
                                "+234 $phoneNumber",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.055,
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 20, top: 20),
                                child: PinCodeTextField(
                                  autofocus: true,
                                  controller: pinCodeController,
                                  hideCharacter: false,
                                  highlight: true,
                                  highlightColor: Colors.black,
                                  defaultBorderColor: Colors.black,
                                  hasTextBorderColor: Colors.black,
                                  maxLength: 6,
                                  hasError: hasError,
                                  pinBoxWidth: 40,
                                  maskCharacter: "*",
                                  onTextChanged: (text) {
                                    setState(() {
                                      hasError = false;
                                      if (text.length == 6) {
                                        codeComplete = true;
                                      }
                                    });
                                  },
                                  onDone: (text) {
                                    print("DONE $text");
                                  },
                                  wrapAlignment: WrapAlignment.start,
                                  pinBoxDecoration: ProvidedPinBoxDecoration
                                      .underlinedPinBoxDecoration,
                                  pinTextStyle: TextStyle(fontSize: 25),
                                  pinTextAnimatedSwitcherTransition:
                                      ProvidedPinBoxTextAnimation
                                          .scalingTransition,
                                  pinTextAnimatedSwitcherDuration:
                                      Duration(milliseconds: 300),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
//                                    Provider.of<AuthModel>(context,listen: false).setAuthProgress(AuthProgress.neutral);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Edit my mobile number',
                                    style:
                                        TextStyle(color: Colors.blueGrey[600]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: FloatingActionButton(
                              onPressed: () {
                                if (codeComplete) {
                                  Provider.of<AuthModel>(context, listen: false)
                                      .signInVerificationCode(
                                          pinCodeController.text.trim(),
                                          context);
                                }
                              },
                              child: Icon(
                                Icons.arrow_forward,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Consumer<AuthModel>(
              builder: (context, authModel, _) {
                if (authModel.authProgress == AuthProgress.verifying) {
                  return LoadingModal();
                }
                return Container(
                  height: 0,
                  width: 0,
                  color: Colors.transparent,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
