import 'package:flutter/material.dart';

class PhoneNumber extends StatefulWidget {
  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

TextEditingController phoneController =
    TextEditingController(text: "08027278021");

class _PhoneNumberState extends State<PhoneNumber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: SafeArea(
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
                                    MediaQuery.of(context).size.width * 0.055,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.065,
                                    height: MediaQuery.of(context).size.width *
                                        0.065,
                                    child: Image.asset("images/nigeria.png"),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.05),
                                  child: Text(
                                    "+234",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.046,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.025),
                                  child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: TextFormField(
                                          autofocus: true,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.046),
                                            hintText: '09012345678',
                                          ),
                                          controller: phoneController,
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
                              Text('By continuing you may receive an SMS for'),
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
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, "phone_verification_page",
                                  arguments: phoneController.text);
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
          )),
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.arrow_forward),
//        onPressed: null,
//      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
