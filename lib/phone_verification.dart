import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget{
  @override
  State createState()=> VerificationPageState();
}

class VerificationPageState extends State<VerificationPage>{
  @override
  Widget build(BuildContext context){
    String phoneNumber=ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
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
                              icon: Icon(Icons.arrow_back, color: Colors.black,),
                              onPressed: ()
                              {
                                Navigator.pop(context);
                              }
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20, top: 12),
                          child: Text('Enter the 4-digit code sent to you at',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width*0.055,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20, top: 12),
                          child: Text("+234 $phoneNumber",
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width*0.055,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20,top: 20),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.1,
                                  child: TextFormField(
                                    autofocus: true,
                                    showCursor: false,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 25
                                      ),
                                      hintText: '0',
                                    ),
                                    style: TextStyle(
                                        fontSize: 25
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.1,
                                  child: TextFormField(
                                    showCursor: false,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 25
                                      ),
                                      hintText: '0',
                                    ),
                                    style: TextStyle(
                                        fontSize: 25
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.1,
                                  child: TextFormField(
                                    showCursor: false,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 25
                                      ),
                                      hintText: '0',
                                    ),
                                    style: TextStyle(
                                        fontSize: 25
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.1,
                                  child: TextFormField(
                                    showCursor: false,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 25
                                      ),
                                      hintText: '0',
                                    ),
                                    style: TextStyle(
                                        fontSize: 25
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
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
                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Text('Edit my mobile number'
                                ,style: TextStyle(
                                    color: Colors.blueGrey[600]
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: FloatingActionButton(
                          onPressed: (){
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
      ),
    );
  }
}