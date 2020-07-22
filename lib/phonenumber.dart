import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/models/auth_model.dart';
import 'package:uber_clone/widgets/loading_modal.dart';

class PhoneNumber extends StatefulWidget {
  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

TextEditingController phoneController = TextEditingController();
TextEditingController nameController = TextEditingController();
GlobalKey<FormState> formKey = GlobalKey();

class _PhoneNumberState extends State<PhoneNumber> {
  @override
  Widget build(BuildContext context) {
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
                      flex: 1,
                      //the list view is here just in case the column overflows(it is very unlikely that happens though)
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
                                  'Please enter your mobile number',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.055,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 30, left: 20),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.065,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.065,
                                        child:
                                            Image.asset("images/nigeria.png"),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                      child: Text(
                                        "+234",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.046,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.025),
                                      child: GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Form(
                                              key: formKey,
                                              child: TextFormField(
                                                autofocus: true,
                                                validator: (value) {
                                                  if (value.length > 10) {
                                                    return "Phone number exceeds 10 digits";
                                                  }

                                                  if (value.length < 10) {
                                                    return "Invalid phone number";
                                                  }
                                                  return null;
                                                },
                                                keyboardType:
                                                    TextInputType.phone,
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.046),
                                                  hintText: '9012345678',
                                                ),
                                                controller: phoneController,
                                              ),
                                            ),
                                          )),
                                    ),
                                  ],
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
                                  Text(
                                      'By continuing you may receive an SMS for'),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                        'verification. Message and data rates may'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text('apply.'),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: FloatingActionButton(
                                onPressed: () async {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  if (formKey.currentState.validate()) {
                                    Provider.of<AuthModel>(context,
                                            listen: false)
                                        .authenticateWithPhoneNumber(
                                            "+234" + phoneController.text,
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
                  if (authModel.authProgress ==
                      AuthProgress.sendingVerificationCode) {
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
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
